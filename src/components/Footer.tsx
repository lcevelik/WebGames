import { Instagram, Youtube, Palette } from "lucide-react";
import { Link } from "react-router-dom";
import { AddGameDialog } from "./AddGameDialog";

export const Footer = () => {
  return (
    <footer className="relative bg-black py-16">
      {/* Gradient overlay */}
      <div className="absolute inset-0 bg-gradient-to-t from-gray-900/50 to-transparent"></div>
      
      <div className="relative container mx-auto px-4">
        <div className="flex flex-col md:flex-row justify-center items-center gap-8 text-gray-400">
          <Link 
            to="https://instagram.com/steadiczech" 
            target="_blank"
            className="flex items-center gap-3 hover:text-white transition-all duration-300 hover:scale-105 group"
          >
            <div className="p-2 rounded-full bg-gray-800 group-hover:bg-gradient-to-r group-hover:from-purple-500 group-hover:to-pink-500 transition-all duration-300">
              <Instagram size={20} className="text-white" />
            </div>
            <span className="font-medium">@steadiczech</span>
          </Link>
          
          <Link 
            to="https://youtube.com/@LiborCevelik" 
            target="_blank"
            className="flex items-center gap-3 hover:text-white transition-all duration-300 hover:scale-105 group"
          >
            <div className="p-2 rounded-full bg-gray-800 group-hover:bg-gradient-to-r group-hover:from-red-500 group-hover:to-pink-500 transition-all duration-300">
              <Youtube size={20} className="text-white" />
            </div>
            <span className="font-medium">Libor Cevelik</span>
          </Link>
          
          <Link 
            to="https://liborevelk.artstation.com" 
            target="_blank"
            className="flex items-center gap-3 hover:text-white transition-all duration-300 hover:scale-105 group"
          >
            <div className="p-2 rounded-full bg-gray-800 group-hover:bg-gradient-to-r group-hover:from-blue-500 group-hover:to-purple-500 transition-all duration-300">
              <Palette size={20} className="text-white" />
            </div>
            <span className="font-medium">ArtStation</span>
          </Link>
        </div>
        
        <div className="mt-8 flex justify-center">
          <AddGameDialog />
        </div>
        
        {/* Bottom border */}
        <div className="mt-12 pt-8 border-t border-gray-800">
          <p className="text-center text-gray-500 text-sm">
            © 2024 SteadiCzech Games. Built with passion for indie developers.
          </p>
        </div>
      </div>
    </footer>
  );
};