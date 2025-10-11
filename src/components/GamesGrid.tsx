import { useState, useEffect } from "react";
import { GameCard } from "./GameCard";
import { useToast } from "@/hooks/use-toast";

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
  const [games, setGames] = useState<Game[]>([
    {
      title: "Save the Chikky",
      image: "https://steadiczech.com/games/game1/cover.png",
      description: "Help Chikky to escape from crabs, how long can Chikky run?",
    },
    {
      title: "Enchanted Quest",
      image: "https://steadiczech.com/games/ench/cover.png",
      description: "Embark on a magical journey through mystical realms",
      url: "https://www.arcanemirage.com/project/2928"
    }
  ]);
  const { toast } = useToast();

  useEffect(() => {
    // Load games from server on component mount
    fetchGames();
  }, []);

  const fetchGames = async () => {
    try {
      const response = await fetch(`${import.meta.env.VITE_SERVER_URL}/games.json`);
      if (!response.ok) {
        throw new Error('Failed to fetch games');
      }
      const data = await response.json();
      // Ensure the demo games are always included
      const gamesWithDemo = [
        {
          title: "Save the Chikky",
          image: "https://steadiczech.com/games/game1/cover.png",
          description: "Help Chikky to escape from crabs, how long can Chikky run?",
        },
        {
          title: "Enchanted Quest",
          image: "https://steadiczech.com/games/ench/cover.png",
          description: "Embark on a magical journey through mystical realms",
          url: "https://www.arcanemirage.com/project/2928"
        },
        ...data
      ];
      setGames(gamesWithDemo);
    } catch (error) {
      console.error('Error fetching games:', error);
      toast({
        title: "Error",
        description: "Failed to load games from server. Showing demo games only.",
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