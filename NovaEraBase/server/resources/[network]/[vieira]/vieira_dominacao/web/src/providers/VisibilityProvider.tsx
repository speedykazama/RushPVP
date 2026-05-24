import React, {
  Context,
  createContext,
  useCallback,
  useContext,
  useEffect,
  useState,
} from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { fetchNui } from "../utils/fetchNui";
import { isEnvBrowser } from "../utils/misc";
import type { AdminSection, NuiShellMode, SetNuiStatePayload } from "../types/nui";
import { DominationPrompt } from "../components/DominationPrompt";
import { DominationHud } from "../components/DominationHud";

interface VisibilityProviderValue {
  visible: boolean;
  shell: NuiShellMode;
  adminSection: AdminSection;
  territoryDetailId: number | null;
  polyEditorVisible: boolean;
  escapeBlocked: boolean;
  setAdminSection: (section: AdminSection) => void;
  openTerritoryDetail: (id: number) => void;
  setVisible: (visible: boolean) => void;
}

const VisibilityCtx = createContext<VisibilityProviderValue | null>(null);

export const VisibilityProvider: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const [visible, setVisible] = useState(false);
  const [shell, setShell] = useState<NuiShellMode>("none");
  const [adminSection, setAdminSectionState] =
    useState<AdminSection>("dominations");
  const [territoryDetailId, setTerritoryDetailId] = useState<number | null>(
    null,
  );
  const [polyEditorVisible, setPolyEditorVisible] = useState(false);
  const [escapeBlocked, setEscapeBlocked] = useState(false);

  const setAdminSection = useCallback((s: AdminSection) => {
    setAdminSectionState(s);
    if (s !== "territory") setTerritoryDetailId(null);
  }, []);

  const openTerritoryDetail = useCallback((id: number) => {
    setTerritoryDetailId(id);
    setAdminSectionState("territory");
  }, []);

  const applyNuiState = useCallback((data: SetNuiStatePayload) => {
    if (!data.visible) {
      setVisible(false);
      setShell("none");
      setAdminSectionState("dominations");
      setTerritoryDetailId(null);
      setPolyEditorVisible(false);
      setEscapeBlocked(false);
      return;
    }
    setVisible(true);
    if (data.mode === "admin") {
      setShell("admin");
      const sec = data.section ?? "dominations";
      setAdminSectionState(sec);
      if (sec !== "territory") setTerritoryDetailId(null);
    }
  }, []);

  useNuiEvent<SetNuiStatePayload>("setNuiState", applyNuiState);

  useNuiEvent<{ id?: number }>("openTerritoryDetail", (d) => {
    if (d?.id != null) {
      setTerritoryDetailId(Number(d.id));
      setAdminSectionState("territory");
    }
  });

  useNuiEvent("territoryDeleted", () => {
    setTerritoryDetailId(null);
    setAdminSectionState("dominations");
  });

  useNuiEvent<{ block?: boolean }>("setEscapeBlock", (d) => {
    setEscapeBlocked(!!d?.block);
  });

  useNuiEvent<{ visible: boolean }>("setPolyEditor", (d) => {
    setPolyEditorVisible(!!d?.visible);
  });

  useEffect(() => {
    if (!visible) return;

    const keyHandler = (e: KeyboardEvent) => {
      if (e.code !== "Escape") return;
      if (document.querySelector(".vd-wizard-root")) return;
      if (escapeBlocked || polyEditorVisible) return;
      if (!isEnvBrowser()) fetchNui("hideFrame");
      else applyNuiState({ visible: false });
    };

    window.addEventListener("keydown", keyHandler);
    return () => window.removeEventListener("keydown", keyHandler);
  }, [visible, escapeBlocked, polyEditorVisible, applyNuiState]);

  return (
    <VisibilityCtx.Provider
      value={{
        visible,
        shell,
        adminSection,
        territoryDetailId,
        polyEditorVisible,
        escapeBlocked,
        setAdminSection,
        openTerritoryDetail,
        setVisible,
      }}
    >
      <div
        style={{ visibility: visible ? "visible" : "hidden", height: "100%" }}
      >
        {children}
      </div>
      <DominationPrompt />
      <DominationHud />
    </VisibilityCtx.Provider>
  );
};

export const useVisibility = () =>
  useContext<VisibilityProviderValue>(
    VisibilityCtx as Context<VisibilityProviderValue>,
  );
