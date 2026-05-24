import React, { useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import type { DominationHudPayload } from "../types/nui";

function UsersGlyph() {
  return (
    <svg
      className="vd-dom-hud-users-ico"
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden
    >
      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
      <circle cx="9" cy="7" r="4" />
      <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
      <path d="M16 3.13a4 4 0 0 1 0 7.75" />
    </svg>
  );
}

export const DominationHud: React.FC = () => {
  const [state, setState] = useState<DominationHudPayload>({ visible: false });

  useNuiEvent<DominationHudPayload>("setDominationHud", setState);

  if (!state.visible || !state.groups?.length) return null;

  return (
    <div className="vd-dom-hud" role="status" aria-live="polite">
      <p className="vd-dom-hud-territory">{state.territory_name}</p>
      {state.stalemate && state.contesting ? (
        <p className="vd-dom-hud-stale">Empate numérico — captura pausada</p>
      ) : null}
      <ul className="vd-dom-hud-list">
        {state.groups.map((g) => {
          const mine = state.my_group && g.key === state.my_group;
          return (
            <li
              key={g.key}
              className={`vd-dom-hud-row${mine ? " vd-dom-hud-row--mine" : ""}`}
            >
              <div className="vd-dom-hud-row-top">
                <span className="vd-dom-hud-label">{g.label}</span>
                <span className="vd-dom-hud-meta">
                  <UsersGlyph />
                  <span>{g.count}</span>
                </span>
              </div>
              <div
                className="vd-dom-hud-bar"
                role="progressbar"
                aria-valuemin={0}
                aria-valuemax={100}
                aria-valuenow={Math.round(g.progress)}
              >
                <div
                  className="vd-dom-hud-bar-fill"
                  style={{ width: `${Math.min(100, Math.max(0, g.progress))}%` }}
                />
              </div>
            </li>
          );
        })}
      </ul>
    </div>
  );
};
