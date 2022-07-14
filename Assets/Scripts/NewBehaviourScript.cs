using UnityEngine;
using System.Collections;

public class SkyboxCamera : MonoBehaviour
{
    public GameObject DummyCamera;
    private TrackingData headTracker;
    private Vector3 startPosition;
    void Start()
    {
        headTracker = Networking.LocalPlayer.GetTrackingData(VRCPlayerApi.TrackingDataType.Head);
        startPosition = transform.position;
    }

    void Update()
    {
        
    }
}
