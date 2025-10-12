import { Gamepad2, Github } from "lucide-react";
import { AddGameDialog } from "./AddGameDialog";

interface FooterProps {
  onGameAdded?: () => void;
}

export const Footer = ({ onGameAdded }: FooterProps) => {
  return (
    <footer className="bg-secondary mt-20 py-8">
      <div className="container mx-auto px-4">
        <div className="flex flex-col md:flex-row justify-center items-center gap-6 text-muted-foreground">
          <div className="flex items-center gap-2">
            <Gamepad2 size={20} />
            <span>Local Games Collection</span>
          </div>
          
          <div className="flex items-center gap-2">
            <Github size={20} />
            <span>Open Source</span>
          </div>
        </div>
        <div className="mt-6 flex justify-center">
          <AddGameDialog onGameAdded={onGameAdded} />
        </div>
      </div>
    </footer>
  );
};