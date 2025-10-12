import { useState, useEffect } from "react";
import { GameCard } from "./GameCard";
import { useToast } from "@/hooks/use-toast";
import { API_ENDPOINTS } from "@/config/api";

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
      // Load games from API endpoint (API server in dev, static file in production)
      const response = await fetch(API_ENDPOINTS.GAMES);
      
      if (response.ok) {
        const games = await response.json();
        console.log('Loaded games:', games);
        setGames(games);
      } else {
        throw new Error('Failed to load games');
      }
    } catch (error) {
      console.error('Error fetching games:', error);
      setGames([]);
      
      toast({
        title: "Error",
        description: "Failed to load games. Please refresh the page.",
        variant: "destructive",
      });
    }
  };

  return (
    <section className="container mx-auto px-4 py-4">
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
        {games.map((game, index) => (
          <GameCard
            key={index}
            title={game.title}
            image={game.image}
            description={game.description}
            url={game.url}
          />
        ))}
      </div>
    </section>
  );
};