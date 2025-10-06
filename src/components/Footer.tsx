import { Instagram, Youtube, Palette } from "lucide-react";
import { Link } from "react-router-dom";
import { AddGameDialog } from "./AddGameDialog";

export const Footer = () => {
  return (
    <footer className="bg-secondary mt-20 py-8">
      <div className="container mx-auto px-4">
        <div className="flex flex-col md:flex-row justify-center items-center gap-6 text-muted-foreground">
          <Link 
            to="https://instagram.com/steadiczech" 
            target="_blank"
            className="flex items-center gap-2 hover:text-primary transition-colors"
          >
            <Instagram size={20} />
            <span>@steadiczech</span>
          </Link>
          
          <Link 
            to="https://youtube.com/@LiborCevelik" 
            target="_blank"
            className="flex items-center gap-2 hover:text-primary transition-colors"
          >
            <Youtube size={20} />
            <span>Libor Cevelik</span>
          </Link>
          
          <Link 
            to="https://liborevelk.artstation.com" 
            target="_blank"
            className="flex items-center gap-2 hover:text-primary transition-colors"
          >
            <Palette size={20} />
            <span>ArtStation</span>
          </Link>
        </div>
        <div className="mt-6 flex justify-center">
          <AddGameDialog />
        </div>
      </div>
    </footer>
  );
};