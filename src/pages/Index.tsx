import { useState } from "react";
import { HeroSection } from "@/components/HeroSection";
import { GamesGrid } from "@/components/GamesGrid";
import { Footer } from "@/components/Footer";
import { VersionCounter } from "@/components/VersionCounter";

const Index = () => {
  const [refreshKey, setRefreshKey] = useState(0);

  const handleGameAdded = () => {
    setRefreshKey(prev => prev + 1);
  };

  return (
    <div className="min-h-screen bg-background">
      <div className="bg-secondary pb-20">
        <VersionCounter />
        <HeroSection />
        <GamesGrid key={refreshKey} selectedCategories={[]} />
        <Footer onGameAdded={handleGameAdded} />
      </div>
    </div>
  );
};

export default Index;