import { useState, useEffect } from "react";
import { GameCard } from "./GameCard";
import { useToast } from "@/hooks/use-toast";
import { Button } from "./ui/button";
import { RefreshCw } from "lucide-react";

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
      // Load games from server
      const response = await fetch(`/games.json?t=${Date.now()}`);
      let serverGames: Game[] = [];
      
      if (response.ok) {
        serverGames = await response.json();
        console.log('Loaded games from server:', serverGames);
      } else {
        console.warn('Failed to load games from server, using localStorage only');
      }

      // Load games from localStorage
      const localGames = JSON.parse(localStorage.getItem('games') || '[]');
      console.log('Loaded games from localStorage:', localGames);

      // Combine both sources, with localStorage games taking precedence for duplicates
      const allGames = [...serverGames];
      localGames.forEach((localGame: Game) => {
        // Check if this game already exists (by title)
        const exists = allGames.some(game => game.title === localGame.title);
        if (!exists) {
          allGames.push(localGame);
        }
      });

      console.log('Combined games:', allGames);
      setGames(allGames);
    } catch (error) {
      console.error('Error fetching games:', error);
      
      // Fallback to localStorage only
      const localGames = JSON.parse(localStorage.getItem('games') || '[]');
      console.log('Using localStorage games as fallback:', localGames);
      setGames(localGames);
      
      toast({
        title: "Warning",
        description: "Using locally saved games. Some games may not be available.",
        variant: "destructive",
      });
    }
  };

  return (
    <section className="container mx-auto px-4 py-4">
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold">Games</h2>
        <Button 
          onClick={fetchGames} 
          variant="outline" 
          size="sm"
          className="flex items-center gap-2"
        >
          <RefreshCw className="h-4 w-4" />
          Refresh
        </Button>
      </div>
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