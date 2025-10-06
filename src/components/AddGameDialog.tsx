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
import { config, getGameImageUrl, getApiUrl } from "@/config/environment";

export const AddGameDialog = () => {
  const [gameName, setGameName] = useState("");
  const [description, setDescription] = useState("");
  const [gameUrl, setGameUrl] = useState("");
  const { toast } = useToast();

  const handleAddGame = async () => {
    try {
      const folderName = gameName.toLowerCase().replace(/\s+/g, '-');
      const gameData = {
        title: gameName,
        image: getGameImageUrl(folderName),
        description: description,
        url: gameUrl || undefined
      };

      console.log('Attempting to save game with data:', gameData);

      const response = await fetch(getApiUrl('save-game.php'), {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(gameData),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Failed to save game card');
      }

      console.log('Server response:', data);

      toast({
        title: "Success",
        description: "Game card has been saved successfully.",
      });
    } catch (error) {
      console.error('Error details:', error);
      
      let errorMessage = 'Failed to save game card. Please check:';
      errorMessage += '\n1. The game folder exists at /games/[game-name]';
      errorMessage += '\n2. The cover.png file exists in the game folder';
      errorMessage += '\n3. File permissions are set correctly';
      
      if (error instanceof Error) {
        errorMessage += `\n\nServer message: ${error.message}`;
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