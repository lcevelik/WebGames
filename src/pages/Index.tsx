import { HeroSection } from "@/components/HeroSection";
import { GamesGrid } from "@/components/GamesGrid";
import { Footer } from "@/components/Footer";
import { VersionCounter } from "@/components/VersionCounter";

const Index = () => {
  return (
    <div className="min-h-screen bg-black">
      <div className="relative">
        <VersionCounter />
        <HeroSection />
        <GamesGrid selectedCategories={[]} />
        <Footer />
      </div>
    </div>
  );
};

export default Index;