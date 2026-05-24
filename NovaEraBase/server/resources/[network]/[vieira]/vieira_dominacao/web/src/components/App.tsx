import React from "react";
import "./App.css";
import { debugData } from "../utils/debugData";
import { useVisibility } from "../providers/VisibilityProvider";
import { AdminLayout } from "./admin/AdminLayout";
import { AdminSectionDomination } from "./admin/AdminSectionDomination";
import { AdminSectionLogs } from "./admin/AdminSectionLogs";
import { AdminTerritoryDetail } from "./admin/AdminTerritoryDetail";
import { PolyEditorOverlay } from "./admin/PolyEditorOverlay";

debugData([
  {
    action: "setNuiState",
    data: { visible: true, mode: "admin", section: "dominations" },
  },
]);

const App: React.FC = () => {
  const { shell, adminSection, polyEditorVisible, territoryDetailId } =
    useVisibility();

  return (
    <>
      {polyEditorVisible && <PolyEditorOverlay />}
      {shell === "admin" && !polyEditorVisible && (
        <AdminLayout>
          {adminSection === "dominations" && <AdminSectionDomination />}
          {adminSection === "territory" && territoryDetailId != null && (
            <AdminTerritoryDetail territoryId={territoryDetailId} />
          )}
          {adminSection === "territory" && territoryDetailId === null && (
            <div className="vd-territory-detail-empty">
              <p className="vd-admin-panel-text">
                Selecione um território na aba <strong>Dominações</strong> clicando
                em um card.
              </p>
            </div>
          )}
          {adminSection === "logs" && <AdminSectionLogs />}
        </AdminLayout>
      )}
    </>
  );
};

export default App;
