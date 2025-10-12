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
      // Load games from server API
      const response = await fetch('http://localhost:3002/api/games');
      
      if (response.ok) {
        const serverGames = await response.json();
        console.log('Loaded games from server API:', serverGames);
        setGames(serverGames);
      } else {
        throw new Error('Failed to load games from server');
      }
    } catch (error) {
      console.error('Error fetching games from server:', error);
      
      // Fallback to static games.json file
      try {
        const response = await fetch(`/games.json?t=${Date.now()}`);
        if (response.ok) {
          const staticGames = await response.json();
          console.log('Using static games.json as fallback:', staticGames);
          setGames(staticGames);
        } else {
          throw new Error('Failed to load static games');
        }
      } catch (fallbackError) {
        console.error('Error loading static games:', fallbackError);
        setGames([]);
        
        toast({
          title: "Error",
          description: "Failed to load games. Please check if the server is running.",
          variant: "destructive",
        });
      }
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