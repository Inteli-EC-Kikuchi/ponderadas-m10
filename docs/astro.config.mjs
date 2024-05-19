import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: process.env.CI ? 'https://inteli-ec-kikuchi.github.io' : 'http://localhost:4321',
	base: '/ponderadas-m10/',
	integrations: [
		starlight({
			title: 'Documentação Kikuchi',
			social: {
				github: 'https://github.com/Inteli-EC-Kikuchi/ponderadas-m10',
			},
			sidebar: [
				{
					label: 'Ponderada 1',
					autogenerate: { directory: 'ponderada1' },
				},
				{
					label: 'Ponderada 2',
					autogenerate: { directory: 'ponderada2' },
				},
				{
					label: 'Ponderada 3',
					autogenerate: { directory: 'ponderada3' },
				}
			],
		}),
	],
});
