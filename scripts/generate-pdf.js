import puppeteer from 'puppeteer';
import { spawn } from 'child_process';

async function generatePdf() {
  console.log('Starting Astro preview server...');
  const previewProcess = spawn('npm', ['run', 'preview'], {
    stdio: 'pipe',
  });

  let serverStarted = false;
  
  // Wait for the server to be ready
  await new Promise((resolve, reject) => {
    previewProcess.stdout.on('data', (data) => {
      const output = data.toString();
      if (output.includes('Local') && output.includes('http://localhost:')) {
        serverStarted = true;
        resolve();
      }
    });

    previewProcess.stderr.on('data', (data) => {
      console.error(`Preview stderr: ${data}`);
    });

    previewProcess.on('close', (code) => {
      if (!serverStarted) {
        reject(new Error(`Preview server exited with code ${code} before starting.`));
      }
    });
    
    // Fallback timeout in case we don't catch the ready message
    setTimeout(() => {
      if (!serverStarted) resolve(); // Attempt anyway after 5s
    }, 5000);
  });

  console.log('Server started. Launching Puppeteer...');
  
  try {
    const browser = await puppeteer.launch({
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
    const page = await browser.newPage();
    
    // Astro preview default port is 4321
    const url = 'http://localhost:4321/one-pager/';
    console.log(`Navigating to ${url}`);
    
    await page.goto(url, { waitUntil: 'networkidle0' });
    
    // We add some custom CSS to ensure it prints well
    await page.addStyleTag({ content: '@page { size: A4; margin: 0; } body { margin: 0; }' });

    console.log('Generating PDF...');
    await page.pdf({
      path: 'public/NicoleShoblom_OnePager.pdf',
      format: 'A4',
      printBackground: true,
      margin: {
        top: '0',
        right: '0',
        bottom: '0',
        left: '0'
      }
    });

    console.log('PDF saved to public/NicoleShoblom_OnePager.pdf');
    await browser.close();
  } catch (error) {
    console.error('Error generating PDF:', error);
    process.exitCode = 1;
  } finally {
    console.log('Killing preview server...');
    previewProcess.kill();
  }
}

generatePdf();
