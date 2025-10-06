import { HeroSection } from "@/components/HeroSection";
import { GamesGrid } from "@/components/GamesGrid";
import { Footer } from "@/components/Footer";
import { VersionCounter } from "@/components/VersionCounter";

const Index = () => {
  return (
    <div className="min-h-screen bg-background">
      <div className="bg-secondary pb-20">
        <VersionCounter />
        <HeroSection />
        <GamesGrid selectedCategories={[]} />
        <Footer />
      </div>
    </div>
  );
};

export default Index;