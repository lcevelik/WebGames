import { useState } from "react";
import { Card } from "./ui/card";

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
    try {
      if (url) {
        console.log('Opening external game:', url);
        window.open(url, '_blank');
      } else {
        const gameUrl = `/games/${title.toLowerCase().replace(/\s+/g, '-')}/index.html`;
        console.log('Opening local game:', gameUrl);
        console.log('Game title:', title);
        console.log('Current protocol:', window.location.protocol);
        console.log('Current host:', window.location.host);
        
        const gameWindow = window.open(gameUrl, '_blank');
        
        if (!gameWindow || gameWindow.closed || typeof gameWindow.closed === 'undefined') {
          console.error('Failed to open game window - popup blocked?');
          alert('Popup blocked! Please allow popups for this site and try again.');
          return;
        }
        
        console.log('Game window opened successfully');
      }
    } catch (error) {
      console.error('Error opening game:', error);
      alert('Error opening game: ' + error.message);
    }
  };

  const handleImageError = () => {
    setImageError(true);
  };

  return (
    <Card
      className="group relative overflow-hidden transition-all duration-300 hover:shadow-xl bg-[#1F2433] hover:bg-[#252A3A] border-0 animate-fade-in rounded-xl shadow-lg shadow-secondary/20 cursor-pointer"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      onClick={handlePlayGame}
    >
      <div className="aspect-[16/9] overflow-hidden">
        <img
          src={imageError ? '/placeholder.svg' : image}
          alt={title}
          onError={handleImageError}
          className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
        />
      </div>
      <div className="p-6">
        <h3 className="text-xl font-display font-semibold mb-2 transition-colors group-hover:text-primary">
          {title}
        </h3>
        <p className="text-sm text-muted-foreground line-clamp-2">{description}</p>
      </div>
    </Card>
  );
};