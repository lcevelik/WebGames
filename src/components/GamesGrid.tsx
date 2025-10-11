import { useState, useEffect } from "react";
import { GameCard } from "./GameCard";
import { useToast } from "@/hooks/use-toast";
import { config, getGameImageUrl } from "@/config/environment";

interface Game {
  title: string;
  image: string;
  description: string;
  url?: string;
}

interface GamesGridProps {
  selectedCategories: string[];
}

export const GamesGrid = ({ selectedCategories }: GamesGridProps) => {
  const [games, setGames] = useState<Game[]>([]);
  const { toast } = useToast();

  useEffect(() => {
    // Load games from server on component mount
    fetchGames();
  }, []);

  const fetchGames = async () => {
    try {
      const response = await fetch(`${config.apiUrl}/games.json`);
      if (!response.ok) {
        throw new Error('Failed to fetch games');
      }
      const data = await response.json();
      setGames(data);
    } catch (error) {
      console.error('Error fetching games:', error);
      toast({
        title: "Error",
        description: "Failed to load games from server.",
        variant: "destructive",
      });
    }
  };

  return (
    <section className="relative bg-black py-20">
      {/* Background elements */}
      <div className="absolute inset-0 bg-gradient-to-b from-black via-gray-900/50 to-black"></div>
      <div className="absolute top-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-gray-800 to-transparent"></div>
      
      <div className="relative container mx-auto px-4">
        {/* Section header */}
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-6xl font-bold text-white mb-6">
            Featured Games
          </h2>
          <p className="text-xl text-gray-400 max-w-2xl mx-auto">
            Discover amazing indie games created by developers around the world
          </p>
        </div>
        
        {/* Masonry-style grid */}
        <div className="columns-1 md:columns-2 lg:columns-3 xl:columns-4 gap-6 space-y-6">
          {games.map((game, index) => (
            <div 
              key={index}
              className="break-inside-avoid mb-6"
              style={{
                animationDelay: `${index * 100}ms`
              }}
            >
              <GameCard
                title={game.title}
                image={game.image}
                description={game.description}
                url={game.url}
              />
            </div>
          ))}
        </div>
        
        {/* Bottom gradient fade */}
        <div className="absolute bottom-0 left-0 w-full h-32 bg-gradient-to-t from-black to-transparent pointer-events-none"></div>
      </div>
    </section>
  );
};