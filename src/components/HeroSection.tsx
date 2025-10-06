export const HeroSection = () => {
  return (
    <section className="relative min-h-[80vh] bg-black overflow-hidden">
      {/* Animated gradient background */}
      <div className="absolute inset-0 bg-gradient-to-br from-purple-900/20 via-blue-900/20 to-pink-900/20"></div>
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-transparent via-black/50 to-black"></div>
      
      {/* Floating geometric shapes */}
      <div className="absolute top-20 left-10 w-32 h-32 bg-gradient-to-r from-blue-500/20 to-purple-500/20 rounded-full blur-xl animate-pulse"></div>
      <div className="absolute top-40 right-20 w-24 h-24 bg-gradient-to-r from-pink-500/20 to-orange-500/20 rounded-full blur-xl animate-pulse delay-1000"></div>
      <div className="absolute bottom-20 left-1/4 w-40 h-40 bg-gradient-to-r from-green-500/20 to-blue-500/20 rounded-full blur-xl animate-pulse delay-2000"></div>
      
      <div className="relative container mx-auto px-4 h-full flex flex-col justify-center items-center text-center py-20">
        {/* NEW badge */}
        <div className="inline-flex items-center px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-sm font-medium mb-8">
          <span className="w-2 h-2 bg-blue-400 rounded-full mr-2 animate-pulse"></span>
          NEW: Play games instantly in your browser
        </div>
        
        <h1 className="text-6xl md:text-8xl lg:text-9xl font-bold mb-8 bg-clip-text text-transparent bg-gradient-to-r from-white via-gray-100 to-gray-300 leading-tight">
          Build better games,
          <br />
          <span className="bg-gradient-to-r from-blue-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">
            faster
          </span>
        </h1>
        
        <p className="text-xl md:text-2xl text-gray-300 mb-12 max-w-4xl font-light leading-relaxed">
          SteadiCzech Games is the platform for indie developers. 
          <br className="hidden md:block" />
          Create freely, publish fast, and scale with our game hosting, analytics, and more.
        </p>
        
        <div className="flex flex-col sm:flex-row gap-4 items-center">
          <button className="px-8 py-4 bg-white text-black font-semibold rounded-lg hover:bg-gray-100 transition-all duration-300 transform hover:scale-105 shadow-2xl">
            Start Playing
          </button>
          <button className="px-8 py-4 border border-gray-600 text-white font-semibold rounded-lg hover:bg-gray-800/50 transition-all duration-300 transform hover:scale-105">
            Upload Your Game
          </button>
        </div>
      </div>
    </section>
  );
};