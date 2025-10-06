import { Badge } from "./ui/badge";

interface CategoriesSectionProps {
  selectedCategories: string[];
  onCategoryToggle: (category: string) => void;
}

const categories = [
  "Action", "Adventure", "RPG", "Strategy", "Simulation", "Puzzle", "Sports"
];

export const CategoriesSection = ({ selectedCategories, onCategoryToggle }: CategoriesSectionProps) => {
  return (
    <section className="container mx-auto px-4 py-8 bg-secondary">
      <h2 className="text-2xl font-display font-bold mb-6 text-center text-white">Browse by Category</h2>
      <div className="flex flex-wrap gap-3 justify-center">
        {categories.map((category) => (
          <Badge
            key={category}
            variant={selectedCategories.includes(category) ? "default" : "secondary"}
            className={`cursor-pointer transition-all duration-300 text-sm py-2 px-4 ${
              selectedCategories.includes(category)
                ? "bg-gradient-to-r from-primary to-accent shadow-lg"
                : "hover:bg-primary/20 hover:text-primary bg-card/50 backdrop-blur-sm"
            }`}
            onClick={() => onCategoryToggle(category)}
          >
            {category}
          </Badge>
        ))}
      </div>
    </section>
  );
};