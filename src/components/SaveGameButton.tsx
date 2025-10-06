import { Button } from "@/components/ui/button";
import { useToast } from "@/hooks/use-toast";

interface SaveGameButtonProps {
  onSave: () => void;
  gameName: string;
}

export const SaveGameButton = ({ onSave, gameName }: SaveGameButtonProps) => {
  const { toast } = useToast();

  const handleSave = () => {
    if (!gameName.trim()) {
      toast({
        title: "Error",
        description: "Please enter a game name",
        variant: "destructive",
      });
      return;
    }

    onSave();
  };

  return (
    <Button onClick={handleSave} className="w-full">
      Save Game Card
    </Button>
  );
};