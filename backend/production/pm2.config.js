module.exports = {
  apps: [
    {
      name: 'aixworkforce360-backend',
      script: 'dist/index.js',
      instances: 2,
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
      },
    },
  ],
};
