import React from "react";
import { fetchNui } from "../../utils/fetchNui";
import { isEnvBrowser } from "../../utils/misc";
import { useVisibility } from "../../providers/VisibilityProvider";
import type { AdminSection } from "../../types/nui";

const titles: Record<AdminSection, { kicker: string; title: string }> = {
  dominations: { kicker: "GESTÃO", title: "Dominações" },
  territory: { kicker: "TERRITÓRIO", title: "Gerenciar área" },
  logs: { kicker: "REGISTRO", title: "Logs" },
};

const nav: { id: AdminSection; label: string }[] = [
  { id: "dominations", label: "Dominações" },
  { id: "territory", label: "Território" },
  { id: "logs", label: "Logs" },
];

export const AdminLayout: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  const { adminSection, territoryDetailId, setAdminSection } = useVisibility();
  const meta = titles[adminSection];

  const close = () => {
    if (!isEnvBrowser()) fetchNui("hideFrame");
    else {
      window.dispatchEvent(
        new MessageEvent("message", {
          data: { action: "setNuiState", data: { visible: false } },
        }),
      );
    }
  };

  return (
    <div className="vd-admin-root">
      <div className="vd-admin-backdrop" onClick={close} aria-hidden />
      <div
        className="vd-admin-shell vd-admin-shell-wide"
        role="dialog"
        aria-modal="true"
        aria-labelledby="vd-admin-title"
      >
        <aside className="vd-admin-sidebar" aria-label="Navegação principal">
          <div className="vd-admin-side-brand">
            <span className="vd-admin-side-k">VIEIRA</span>
            <span className="vd-admin-side-t">Dominação</span>
          </div>
          <nav className="vd-admin-side-nav">
            {nav.map((item) => {
              const isTerritory = item.id === "territory";
              const disabled = isTerritory && territoryDetailId === null;
              return (
                <button
                  key={item.id}
                  type="button"
                  disabled={disabled}
                  title={
                    disabled
                      ? "Selecione um território na lista de Dominações"
                      : undefined
                  }
                  className={
                    item.id === adminSection
                      ? "vd-admin-side-link vd-admin-side-link-active"
                      : "vd-admin-side-link"
                  }
                  onClick={() => !disabled && setAdminSection(item.id)}
                >
                  {item.label}
                </button>
              );
            })}
          </nav>
          <button
            type="button"
            className="vd-admin-side-close"
            onClick={close}
          >
            Fechar painel
          </button>
        </aside>

        <div className="vd-admin-main">
          <header className="vd-admin-top vd-admin-top-inline">
            <div>
              <p className="vd-admin-kicker">{meta.kicker}</p>
              <h1 id="vd-admin-title" className="vd-admin-title">
                {meta.title}
              </h1>
            </div>
          </header>
          <div className="vd-admin-body vd-admin-body-scroll">{children}</div>
        </div>
      </div>
    </div>
  );
};
