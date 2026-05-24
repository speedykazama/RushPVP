export type AdminSection = "dominations" | "territory" | "logs";

export type NuiShellMode = "none" | "admin";

export type SetNuiStatePayload =
  | { visible: false }
  | {
      visible: true;
      mode: "admin";
      section?: AdminSection;
    };

/** Apenas polyzone no fluxo atual */
export type PolyEditorPhase = "poly";

export type PolyEditorPayload =
  | { visible: false }
  | {
      visible: true;
      phase: PolyEditorPhase;
      pointCount?: number;
    };

export type DominationPoint = { x: number; y: number };

export type DominationWizardPayload = {
  minZ: number;
  maxZ: number;
  points: DominationPoint[];
};

export type TerritoryRow = {
  id: number;
  name: string;
  image_url: string;
  center: { x: number; y: number; z: number };
  min_z: number | null;
  max_z: number | null;
  point_count: number;
  owner_group: string | null;
  /** Nome amigável se `owner_group` existir em `Config.AllowedGroups` */
  owner_label?: string | null;
  cooldown_ends: number | null;
};

export type TerritoryDetail = TerritoryRow & {
  points: DominationPoint[];
  created_at?: string | null;
  updated_at?: string | null;
};

/** Prompt inferior no mundo (sem foco NUI). */
export type DominationPromptPayload =
  | { visible: false; domination_active?: boolean }
  | {
      visible: true;
      id: number;
      name: string;
      image_url: string;
      owner_group: string | null;
      owner_label?: string | null;
      cooldown_ends: number | null;
      domination_active?: boolean;
    };

export type DominationHudGroup = {
  key: string;
  label: string;
  count: number;
  progress: number;
};

export type DominationHudPayload =
  | { visible: false; territory_id?: number }
  | {
      visible: true;
      territory_id: number;
      territory_name: string;
      groups: DominationHudGroup[];
      contesting: boolean;
      stalemate: boolean;
      leader_count: number;
      runner_count: number;
      my_group?: string | null;
    };
