shader_type canvas_item;

uniform float progresso : hint_range(0.0, 1.0) = 0.0;
uniform float largura_brilho : hint_range(0.0, 0.5) = 0.15;

void fragment() {
	vec4 cor_tex = texture(TEXTURE, UV);
	
	// Calcula a posição do raio de brilho na diagonal
	float posicao = UV.x + UV.y * 0.5;
	float centro = progresso * 2.0 - 0.5;
	float intensidade = smoothstep(centro - largura_brilho, centro, posicao) - smoothstep(centro, centro + largura_brilho, posicao);
	
	// Adiciona a cor branca do brilho mantendo a transparência original
	vec3 cor_final = cor_tex.rgb + vec3(intensidade * 0.8);
	COLOR = vec4(cor_final, cor_tex.a);
}
