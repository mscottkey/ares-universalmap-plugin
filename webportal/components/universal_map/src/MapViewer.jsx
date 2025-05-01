import React, { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";

const MapViewer = () => {
  const rootEl = document.getElementById("map-root");
  const mapId = rootEl?.dataset?.mapId;

  const [mapData, setMapData] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!mapId) {
      setError("Map ID is missing.");
      return;
    }

    fetch(`/api/map?id=${mapId}`)
      .then((res) => {
        if (!res.ok) throw new Error("Failed to fetch map.");
        return res.json();
      })
      .then((data) => {
        setMapData(data);
      })
      .catch((err) => {
        setError(err.message);
      });
  }, [mapId]);

  if (error) {
    return <div style={{ color: "red" }}>Error: {error}</div>;
  }

  if (!mapData) {
    return <div>Loading map...</div>;
  }

  return (
    <div style={{ padding: "1em", backgroundColor: "#222", color: "white" }}>
      <h2>{mapData.title}</h2>
      <p>Mode: {mapData.mode}</p>
      <p>Fog of War: {mapData.fog_enabled ? "On" : "Off"}</p>
    </div>
  );
};

const root = createRoot(document.getElementById("map-root"));
root.render(<MapViewer />);
