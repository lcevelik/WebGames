import { useState } from "react";
import { Card } from "./ui/card";
import { config, getGameUrl, getGameImageUrl } from "@/config/environment";

interface GameCardProps {
  title: string;
  image: string;
  description: string;
  url?: string;
}

export const GameCard = ({ title, image, description, url }: GameCardProps) => {
  const [isHovered, setIsHovered] = useState(false);
  const [imageError, setImageError] = useState(false);

  const handlePlayGame = () => {
    if (url) {
      window.open(url, '_blank');
    } else if (title === "Save the Chikky") {
      window.open(getGameUrl("game1"), '_blank');
    } else {
      const gameUrl = url || getGameUrl(title);
      window.open(gameUrl, '_blank');
    }
  };

  const handleImageError = () => {
    setImageError(true);
  };

  return (
    <Card
      className="group relative overflow-hidden transition-all duration-500 hover:shadow-2xl bg-gray-900/50 hover:bg-gray-800/70 border border-gray-800/50 hover:border-gray-700/50 rounded-2xl shadow-lg hover:shadow-purple-500/10 cursor-pointer backdrop-blur-sm animate-fade-in"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      onClick={handlePlayGame}
      style={{
        animation: 'fadeInUp 0.6s ease-out forwards',
        opacity: 0,
        transform: 'translateY(20px)'
      }}
    >
      {/* Gradient overlay on hover */}
      <div className="absolute inset-0 bg-gradient-to-br from-purple-500/10 via-blue-500/5 to-pink-500/10 opacity-0 group-hover:opacity-100 transition-opacity duration-500 z-10"></div>
      
      {/* Play button overlay */}
      <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 z-20">
        <div className="w-16 h-16 bg-white/90 rounded-full flex items-center justify-center shadow-2xl transform scale-75 group-hover:scale-100 transition-transform duration-300">
          <svg className="w-6 h-6 text-black ml-1" fill="currentColor" viewBox="0 0 24 24">
            <path d="M8 5v14l11-7z"/>
          </svg>
        </div>
      </div>
      
      <div className="aspect-[4/3] overflow-hidden relative">
        <img
          src={imageError ? config.defaultImageUrl : image}
          alt={title}
          onError={handleImageError}
          className="h-full w-full object-cover transition-all duration-500 group-hover:scale-110 group-hover:brightness-110"
        />
        {/* Image overlay gradient */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
      </div>
      
      <div className="p-6 relative z-10">
        <h3 className="text-xl font-bold mb-3 text-white group-hover:text-gray-100 transition-colors duration-300">
          {title}
        </h3>
        <p className="text-sm text-gray-400 group-hover:text-gray-300 line-clamp-2 leading-relaxed transition-colors duration-300">
          {description}
        </p>
        
        {/* Bottom accent line */}
        <div className="mt-4 h-0.5 bg-gradient-to-r from-purple-500 to-blue-500 w-0 group-hover:w-full transition-all duration-500"></div>
      </div>
    </Card>
  );
};