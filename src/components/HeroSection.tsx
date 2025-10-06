export const HeroSection = () => {
  return (
    <section className="relative min-h-[300px] bg-secondary">
      <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxwYXRoIGQ9Ik0zNiAxOGMtOS45NDEgMC0xOCA4LjA1OS0xOCAxOHM4LjA1OSAxOCAxOCAxOGMxMC4wMzcgMCAxOC04LjA1OSAxOC0xOHMtNy45NjMtMTgtMTgtMTh6bTAgMzJjLTcuNzMyIDAtMTQtNi4yNjgtMTQtMTRzNi4yNjgtMTQgMTQtMTQgMTQgNi4yNjggMTQgMTQtNi4yNjggMTQtMTQgMTR6Ii8+PC9nPjwvc3ZnPg==')] opacity-5"></div>
      <div className="relative container mx-auto px-4 h-full flex flex-col justify-center items-center text-center py-8">
        <h1 className="font-display text-6xl md:text-7xl font-bold mb-4 bg-clip-text text-transparent bg-gradient-to-r from-primary to-accent">
          SteadiCzech Games
        </h1>
        <p className="text-lg md:text-xl text-muted mb-4 max-w-2xl font-medium">
          Discover and play amazing indie games directly in your browser
        </p>
      </div>
    </section>
  );
};