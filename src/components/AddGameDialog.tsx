import { useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import { GameForm } from "./GameForm";
import { SaveGameButton } from "./SaveGameButton";

interface AddGameDialogProps {
  onGameAdded?: () => void;
}

export const AddGameDialog = ({ onGameAdded }: AddGameDialogProps) => {
  const [gameName, setGameName] = useState("");
  const [description, setDescription] = useState("");
  const [gameUrl, setGameUrl] = useState("");
  const { toast } = useToast();

  const handleAddGame = async () => {
    try {
      const folderName = gameName.toLowerCase().replace(/\s+/g, '-');
      const gameData = {
        title: gameName,
        image: `/games/${folderName}/cover.png`,
        description: description,
        url: gameUrl || undefined
      };

      console.log('Adding game to server:', gameData);

      const response = await fetch('http://localhost:3002/api/games', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(gameData),
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Failed to add game');
      }

      console.log('Game added successfully to server:', result);

      toast({
        title: "Success",
        description: "Game card has been added successfully!",
      });

      // Reset form
      setGameName("");
      setDescription("");
      setGameUrl("");

      // Notify parent component to refresh games list
      if (onGameAdded) {
        onGameAdded();
      }
    } catch (error) {
      console.error('Error details:', error);
      
      let errorMessage = 'Failed to add game card. Please try again.';
      
      if (error instanceof Error) {
        errorMessage += `\n\nError: ${error.message}`;
      }

      toast({
        title: "Error",
        description: errorMessage,
        variant: "destructive",
      });
    }
  };

  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button className="bg-secondary/50 text-muted-foreground hover:bg-secondary/80 transition-colors">
          Add Game
        </Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Add New Game Card</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-4">
          <GameForm
            gameName={gameName}
            description={description}
            gameUrl={gameUrl}
            onGameNameChange={setGameName}
            onDescriptionChange={setDescription}
            onGameUrlChange={setGameUrl}
          />
          <SaveGameButton
            onSave={handleAddGame}
            gameName={gameName}
          />
          <p className="text-sm text-muted-foreground mt-4">
            Note: Game cards will be saved to the server. Make sure the game folder exists with a cover.png image.
          </p>
        </div>
      </DialogContent>
    </Dialog>
  );
};