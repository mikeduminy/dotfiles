import { FinickyConfig } from "../../../../../Applications/Finicky.app/Contents/Resources/finicky";

const config: FinickyConfig = {
  defaultBrowser: {
    name: "Google Chrome",
    profile: "Work",
  },
  options: {
    // Check for updates. Default: true
    checkForUpdates: true,
    // Log every request to file. Default: false
    logRequests: false,
    // Keep Finicky running in the background
    keepRunning: true,
    // Hide the Finicky icon from the menu bar
    hideIcon: false,
  },
  handlers: [
    {
      match: ["work links"],
      browser: {
        name: "Google Chrome",
        profile: "Work",
      },
    },
  ],
};

export default config;
