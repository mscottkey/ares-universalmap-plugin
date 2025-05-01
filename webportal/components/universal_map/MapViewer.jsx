import React from "react";
import { createRoot } from "react-dom/client";

const MapViewer = () => {
  const rootEl = document.getElementById("map-root");
  const mapId = rootEl?.dataset?.mapId;

  return (
    <div style={{ padding: "1em", backgroundColor: "#222", color: "white" }}>
      <h2>Map Viewer</h2>
      <p>Map ID: {mapId}</p>
      {/* You can now call /api/map?id=... */}
    </div>
  );
};

const root = createRoot(document.getElementById("map-root"));
root.render(<MapViewer />);
