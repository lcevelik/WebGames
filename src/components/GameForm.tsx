import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";

interface GameFormProps {
  gameName: string;
  description: string;
  gameUrl: string;
  onGameNameChange: (value: string) => void;
  onDescriptionChange: (value: string) => void;
  onGameUrlChange: (value: string) => void;
}

export const GameForm = ({
  gameName,
  description,
  gameUrl,
  onGameNameChange,
  onDescriptionChange,
  onGameUrlChange,
}: GameFormProps) => {
  return (
    <div className="space-y-4">
      <div className="space-y-2">
        <Input
          placeholder="Enter game name"
          value={gameName}
          onChange={(e) => onGameNameChange(e.target.value)}
        />
      </div>
      <div className="space-y-2">
        <Input
          placeholder="Enter game URL (optional)"
          value={gameUrl}
          onChange={(e) => onGameUrlChange(e.target.value)}
        />
      </div>
      <div className="space-y-2">
        <Textarea
          placeholder="Enter game description (optional)"
          value={description}
          onChange={(e) => onDescriptionChange(e.target.value)}
          className="min-h-[100px]"
        />
      </div>
    </div>
  );
};