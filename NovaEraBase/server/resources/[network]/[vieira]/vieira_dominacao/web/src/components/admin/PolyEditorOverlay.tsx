import React, { useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import type { PolyEditorPayload } from "../../types/nui";

export const PolyEditorOverlay: React.FC = () => {
  const [state, setState] = useState<PolyEditorPayload>({ visible: false });

  useNuiEvent<PolyEditorPayload>("setPolyEditor", setState);

  if (!state.visible) return null;

  const lines = [
    `Vértices: ${state.pointCount ?? 0} (mínimo 3)`,
    "E — adicionar vértice na sua posição atual",
    "Backspace — desfazer último vértice",
    "Enter — finalizar polyzone",
    "ESC — cancelar",
  ];

  return (
    <div className="vd-poly-overlay" role="status" aria-live="polite">
      <div className="vd-poly-overlay-inner shadcn-card-elevated">
        <p className="vd-poly-overlay-kicker">Polyzone</p>
        <ul className="vd-poly-overlay-list">
          {lines.map((t) => (
            <li key={t}>{t}</li>
          ))}
        </ul>
      </div>
    </div>
  );
};
