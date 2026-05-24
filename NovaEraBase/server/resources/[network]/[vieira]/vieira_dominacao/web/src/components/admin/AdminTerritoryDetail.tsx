import React, { useCallback, useEffect, useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";
import { useVisibility } from "../../providers/VisibilityProvider";
import type { TerritoryDetail } from "../../types/nui";

function formatCooldownEnd(ts: number | null): string {
  if (ts == null || ts <= 0) return "Sem cooldown";
  const ms = ts > 1e12 ? ts : ts * 1000;
  const d = new Date(ms);
  if (Number.isNaN(d.getTime())) return "Cooldown ativo";
  return d.toLocaleString("pt-BR");
}

interface Props {
  territoryId: number;
}

export const AdminTerritoryDetail: React.FC<Props> = ({ territoryId }) => {
  const { setAdminSection } = useVisibility();
  const [row, setRow] = useState<TerritoryDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [err, setErr] = useState<string | null>(null);

  const [name, setName] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [ownerGroup, setOwnerGroup] = useState("");
  const [cooldownHours, setCooldownHours] = useState("24");
  const [savingMeta, setSavingMeta] = useState(false);
  const [savingOwner, setSavingOwner] = useState(false);
  const [savingCd, setSavingCd] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [confirmDel, setConfirmDel] = useState(false);

  const load = useCallback(() => {
    setLoading(true);
    setErr(null);
    fetchNui<TerritoryDetail | null>("getTerritoryDetail", { id: territoryId })
      .then((r) => {
        if (!r || !r.id) {
          setRow(null);
          setErr("Território não encontrado.");
          return;
        }
        setRow(r);
        setName(r.name);
        setImageUrl(r.image_url || "");
        setOwnerGroup(r.owner_group || "");
      })
      .catch(() => {
        setRow(null);
        setErr("Falha ao carregar.");
      })
      .finally(() => setLoading(false));
  }, [territoryId]);

  useEffect(() => {
    load();
  }, [load]);

  useNuiEvent<{ id?: number }>("territoryDetailRefresh", (d) => {
    if (d?.id != null && Number(d.id) === territoryId) load();
  });

  const teleport = () => {
    fetchNui("teleportToTerritory", { id: territoryId }).catch(() => undefined);
  };

  const startPolyEdit = () => {
    fetchNui("startTerritoryPolyEdit", { id: territoryId }).catch(
      () => undefined,
    );
  };

  const saveMeta = () => {
    setSavingMeta(true);
    fetchNui("updateTerritoryMeta", {
      id: territoryId,
      name: name.trim(),
      image_url: imageUrl.trim(),
    })
      .then(() => load())
      .finally(() => setSavingMeta(false));
  };

  const saveOwner = () => {
    setSavingOwner(true);
    fetchNui("setTerritoryOwner", {
      id: territoryId,
      owner_group: ownerGroup.trim(),
    })
      .then(() => load())
      .finally(() => setSavingOwner(false));
  };

  const applyCooldownHours = () => {
    const h = parseFloat(cooldownHours.replace(",", "."));
    if (Number.isNaN(h) || h <= 0) return;
    const ends = Math.floor(Date.now() / 1000 + h * 3600);
    setSavingCd(true);
    fetchNui("setTerritoryCooldown", { id: territoryId, cooldown_ends: ends })
      .then(() => load())
      .finally(() => setSavingCd(false));
  };

  const clearCooldown = () => {
    setSavingCd(true);
    fetchNui("setTerritoryCooldown", { id: territoryId, clear: true })
      .then(() => load())
      .finally(() => setSavingCd(false));
  };

  const doDelete = () => {
    setDeleting(true);
    fetchNui<{ ok?: boolean }>("deleteTerritory", { id: territoryId })
      .then((r) => {
        if (r?.ok) setAdminSection("dominations");
      })
      .finally(() => {
        setDeleting(false);
        setConfirmDel(false);
      });
  };

  if (loading) {
    return <p className="vd-admin-panel-text">Carregando território…</p>;
  }

  if (err || !row) {
    return (
      <div className="vd-territory-detail-empty">
        <p className="vd-admin-panel-text">{err || "Sem dados."}</p>
        <button
          type="button"
          className="vd-btn vd-btn-outline"
          onClick={() => setAdminSection("dominations")}
        >
          Voltar à lista
        </button>
      </div>
    );
  }

  return (
    <div className="vd-territory-detail">
      <div className="vd-territory-detail-hero shadcn-card-elevated">
        {row.image_url ? (
          <img
            className="vd-territory-detail-hero-img"
            src={row.image_url}
            alt=""
            onError={(e) => {
              (e.target as HTMLImageElement).style.display = "none";
            }}
          />
        ) : (
          <div className="vd-territory-detail-hero-ph" />
        )}
        <div>
          <h2 className="vd-territory-detail-name">{row.name}</h2>
          <p className="vd-territory-detail-id">ID #{row.id}</p>
        </div>
      </div>

      <div className="vd-territory-detail-actions">
        <button type="button" className="vd-btn vd-btn-primary" onClick={teleport}>
          Teleportar (centro)
        </button>
        <button type="button" className="vd-btn vd-btn-outline" onClick={startPolyEdit}>
          Refazer polyzone
        </button>
        <button
          type="button"
          className="vd-btn vd-btn-outline"
          onClick={() => setAdminSection("dominations")}
        >
          Lista de dominações
        </button>
      </div>

      <div className="vd-territory-detail-grid">
        <section className="vd-detail-card shadcn-card-elevated">
          <h3 className="vd-detail-card-title">Identidade & mídia</h3>
          <label className="vd-wizard-label" htmlFor="td-name">
            Nome
          </label>
          <input
            id="td-name"
            className="vd-wizard-input shadcn-input"
            value={name}
            onChange={(e) => setName(e.target.value)}
            maxLength={128}
          />
          <label className="vd-wizard-label" htmlFor="td-url">
            URL da imagem
          </label>
          <input
            id="td-url"
            className="vd-wizard-input shadcn-input"
            value={imageUrl}
            onChange={(e) => setImageUrl(e.target.value)}
            maxLength={512}
          />
          <div className="vd-detail-card-actions">
            <button
              type="button"
              className="vd-btn vd-btn-primary"
              disabled={savingMeta || !name.trim()}
              onClick={saveMeta}
            >
              {savingMeta ? "Salvando…" : "Salvar nome / URL"}
            </button>
          </div>
        </section>

        <section className="vd-detail-card shadcn-card-elevated">
          <h3 className="vd-detail-card-title">Controle de facção</h3>
          <label className="vd-wizard-label" htmlFor="td-owner">
            Grupo dominando (vRP)
          </label>
          <input
            id="td-owner"
            className="vd-wizard-input shadcn-input"
            value={ownerGroup}
            onChange={(e) => setOwnerGroup(e.target.value)}
            placeholder="Vazio = ninguém"
            maxLength={64}
          />
          <div className="vd-detail-card-actions">
            <button
              type="button"
              className="vd-btn vd-btn-outline"
              disabled={savingOwner}
              onClick={saveOwner}
            >
              {savingOwner ? "Salvando…" : "Salvar dono"}
            </button>
          </div>
        </section>

        <section className="vd-detail-card shadcn-card-elevated">
          <h3 className="vd-detail-card-title">Cooldown</h3>
          <p className="vd-detail-muted">
            Atual: {formatCooldownEnd(row.cooldown_ends)}
          </p>
          <label className="vd-wizard-label" htmlFor="td-cd">
            Duração a partir de agora (horas)
          </label>
          <input
            id="td-cd"
            className="vd-wizard-input shadcn-input"
            value={cooldownHours}
            onChange={(e) => setCooldownHours(e.target.value)}
            inputMode="decimal"
          />
          <div className="vd-detail-card-actions">
            <button
              type="button"
              className="vd-btn vd-btn-primary"
              disabled={savingCd}
              onClick={applyCooldownHours}
            >
              Aplicar cooldown
            </button>
            <button
              type="button"
              className="vd-btn vd-btn-outline"
              disabled={savingCd}
              onClick={clearCooldown}
            >
              Limpar cooldown
            </button>
          </div>
        </section>

        <section className="vd-detail-card shadcn-card-elevated">
          <h3 className="vd-detail-card-title">Geometria & dados</h3>
          <dl className="vd-detail-dl">
            <div>
              <dt>Centro (mapa)</dt>
              <dd>
                {row.center.x.toFixed(2)}, {row.center.y.toFixed(2)},{" "}
                {row.center.z.toFixed(2)}
              </dd>
            </div>
            <div>
              <dt>Vértices</dt>
              <dd>{row.point_count}</dd>
            </div>
            <div>
              <dt>min Z / max Z</dt>
              <dd>
                {row.min_z ?? "—"} / {row.max_z ?? "—"}
              </dd>
            </div>
            {row.created_at && (
              <div>
                <dt>Criado em</dt>
                <dd>{row.created_at}</dd>
              </div>
            )}
            {row.updated_at && (
              <div>
                <dt>Atualizado</dt>
                <dd>{row.updated_at}</dd>
              </div>
            )}
          </dl>
        </section>

        <section className="vd-detail-card vd-detail-card-danger shadcn-card-elevated">
          <h3 className="vd-detail-card-title">Zona perigosa</h3>
          <p className="vd-detail-muted">
            Excluir remove o território do banco de forma permanente.
          </p>
          {!confirmDel ? (
            <button
              type="button"
              className="vd-btn vd-btn-destructive"
              onClick={() => setConfirmDel(true)}
            >
              Excluir território…
            </button>
          ) : (
            <div className="vd-detail-card-actions">
              <button
                type="button"
                className="vd-btn vd-btn-outline"
                disabled={deleting}
                onClick={() => setConfirmDel(false)}
              >
                Cancelar
              </button>
              <button
                type="button"
                className="vd-btn vd-btn-destructive"
                disabled={deleting}
                onClick={doDelete}
              >
                {deleting ? "Excluindo…" : "Confirmar exclusão"}
              </button>
            </div>
          )}
        </section>
      </div>
    </div>
  );
};
