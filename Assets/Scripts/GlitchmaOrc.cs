using System.Collections;
using UnityEngine;

public class GlitchmaOrc : MonoBehaviour
{
    [Range(0f, 1f)]
    public float glitchChance = 0.1f;
    [Range(0f, 1f)]
    public float maxGlitchTime = 0.25f;
    [Range(0f, 1f)]
    public float minGlitchTime = 0.05f;
    [Range(0f, 1f)]
    public float minGlitchWaitTime = 0.25f;

    [Range(0f, 1f)]
    public float glitchCutoutThreshold = 0.6f;
    [Range(0f, 1f)]
    public float glitchScaleValue = 1f;

    private bool waiting = false;
    private float glitchTime = 0f;

    private SkinnedMeshRenderer hologramRenderer;

    void Start()
    {
        hologramRenderer = GetComponent<SkinnedMeshRenderer>();        
        hologramRenderer.material.SetFloat("_CutoutThreshold", 0f);
        hologramRenderer.material.SetFloat("_GlitchScaleValue", 0f);
    }

    // Update is called once per frame
    void Update()
    {
        float glitchRoll = Random.Range(0f, 1f);
        if (glitchRoll <= glitchChance && !waiting)
        {
            StartCoroutine(RunGlitch());
        }
        
    }
    
    IEnumerator RunGlitch()
    {
        StartCoroutine(Glitch());
        waiting = true;
        yield return new WaitForSeconds(minGlitchWaitTime);
        waiting = false;
    }

    IEnumerator Glitch()
    {
        glitchTime = Random.Range(minGlitchTime, maxGlitchTime);
        hologramRenderer.material.SetFloat("_CutoutThreshold", glitchCutoutThreshold);
        hologramRenderer.material.SetFloat("_GlitchScaleValue", glitchScaleValue);
        yield return new WaitForSeconds(glitchTime);

        hologramRenderer.material.SetFloat("_CutoutThreshold", 0f);
        hologramRenderer.material.SetFloat("_GlitchScaleValue", 0f);
    }
}
