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
      className="group relative overflow-hidden transition-all duration-300 hover:shadow-xl bg-[#1F2433] hover:bg-[#252A3A] border-0 animate-fade-in rounded-xl shadow-lg shadow-secondary/20 cursor-pointer"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      onClick={handlePlayGame}
    >
      <div className="aspect-[16/9] overflow-hidden">
        <img
          src={imageError ? config.defaultImageUrl : image}
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