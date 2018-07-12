--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.22
-- Dumped by pg_dump version 9.3.22
-- Started on 2018-05-08 21:40:24 -05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 222 (class 1259 OID 19248)
-- Name: resource_view; Type: TABLE; Schema: public; Owner: ckan_default; Tablespace: 
--

CREATE TABLE public.resource_view (
    id text NOT NULL,
    resource_id text,
    title text,
    description text,
    view_type text NOT NULL,
    "order" integer NOT NULL,
    config text
);


ALTER TABLE public.resource_view OWNER TO ckan_default;

--
-- TOC entry 2787 (class 0 OID 19248)
-- Dependencies: 222
-- Data for Name: resource_view; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.resource_view (id, resource_id, title, description, view_type, "order", config) FROM stdin;
87e91068-853c-40d5-a959-8db9050acaf3	2547c963-45da-42d5-b9dc-ddc5590f65ab	ArcGIS FeatureServer Service		ags_fs_view	0	\N
9c98ffa3-dc52-4b32-9def-4939baf18db5	38e2e2bb-eb07-4c94-9528-982711078e23	ArcGIS FeatureServer Service		ags_fs_view	0	\N
ce0ae9ac-5fb0-4e08-a089-e6fdf1985737	dfcb80f4-57d1-43e8-b291-a91e5b2b6361	ArcGIS FeatureServer Service		ags_fs_view	0	\N
750cb73d-a3e6-41ab-9c94-8586366913bc	2de8b584-084e-48b4-ae7a-9a42727585b1	ArcGIS FeatureServer Service		ags_fs_view	0	\N
f747f062-928f-42fa-bb6c-81db71693e2c	5831d880-7179-4eff-8352-74be1b3b3bbe	Website		webpage_view	0	\N
1ab2f6dd-a8cc-4e5e-9e0d-e8e7a9314733	cf77e352-4f8d-481e-9bd6-9b1493305d95	ArcGIS FeatureServer Service		ags_fs_view	0	\N
0a26307b-1e68-4fca-86b3-569d5dd3d75e	a37fa6c8-4ecd-43c5-b8ed-24a7548e3eb9	Website		webpage_view	0	\N
756cacbd-3ba5-44a2-aa3c-2fb3e66ebeef	7dde548e-66b1-4055-ac45-e5c348ef06ea	ArcGIS FeatureServer Service		ags_fs_view	0	\N
e8a3bde3-c57f-4e93-b20c-6f7a23100da1	fdfa90b2-56e0-44e3-982b-d9d276e6ca9a	ArcGIS FeatureServer Service		ags_fs_view	0	\N
18930cfa-0214-40b8-b2de-977ec451a440	8eb65b03-a38d-49ff-8654-3fbe28c8ffa3	Data Explorer		recline_view	0	\N
a5cb8512-5b92-4c5b-8413-2dd37f3438a9	aa410608-f83b-437b-81d0-41e2090c76ec	Website		webpage_view	0	\N
cb3a1c2c-d07a-4a4c-ab7b-b6493c5e8d16	8eb65b03-a38d-49ff-8654-3fbe28c8ffa3	Map viewer		geo_view	1	\N
8b822e1d-aae6-4867-a04f-b4d7640afc39	0ab8ad03-ca50-4e38-8a7e-caa6aaa87f6b	ArcGIS FeatureServer Service		ags_fs_view	0	\N
de15ae9d-e0b3-4636-8f29-6786a47e407d	ad5f8e9b-856c-4d65-b655-e7aa2f1c6a5f	ArcGIS FeatureServer Service		ags_fs_view	0	\N
17c4a18a-af50-496f-b81d-323c020b34ba	65803c4c-edca-4770-8f4a-f7f6663681ec	ArcGIS FeatureServer Service		ags_fs_view	0	\N
70dd2da6-fdf0-48a4-8aac-00fe7118766e	0340cb7f-d631-450a-8357-150d3caa9f3a	ArcGIS FeatureServer Service		ags_fs_view	0	\N
405ce0f1-9187-4a91-8448-02681e6f657c	9ab1502e-ce6f-4f4d-8834-8ab96ddcbeb2	ArcGIS FeatureServer Service		ags_fs_view	0	\N
e48389e3-fc50-4299-a224-8709ce744e91	e3653de5-54ae-4514-8d31-b172d0a6431f	ArcGIS FeatureServer Service		ags_fs_view	0	\N
57a92a8a-a36f-41c5-ab68-f00f84c88382	6c0fc13f-f741-4433-bb7d-711c8ab80d66	ArcGIS FeatureServer Service		ags_fs_view	0	\N
e53d4553-b234-47ad-9371-e6239b8a75e0	e92f9ddf-cc66-459e-a99f-a69a92c716ad	ArcGIS FeatureServer Service		ags_fs_view	0	\N
d02b9f06-c45c-4e8c-9d1c-b9b701ffaec1	cf07735a-a739-4655-a4fa-8e2f3df22a86	ArcGIS FeatureServer Service		ags_fs_view	0	\N
d9bb780e-5b76-446d-83d1-65fe264d1206	2faad1bc-4177-4b40-97d3-449fe0c22c25	ArcGIS FeatureServer Service		ags_fs_view	0	\N
fb204b72-f0be-428c-b8d8-1701ae5b350f	16b26e00-3214-40ed-b63d-0a529a68af9a	ArcGIS FeatureServer Service		ags_fs_view	0	\N
4581a0c3-820d-4818-ac2c-133276821552	2a94d716-2609-4e2a-9a69-42ac9341efb8	ArcGIS FeatureServer Service		ags_fs_view	0	\N
c4eacdb8-f5ac-4546-8d5f-67f5c627d75c	a457698f-5915-4103-a7a8-f88327baf5f8	ArcGIS FeatureServer Service		ags_fs_view	0	\N
095f4238-92db-484f-9f8a-121e1f2f2054	49b5e682-107f-4465-bafb-e5f49ace60ee	ArcGIS FeatureServer Service		ags_fs_view	0	\N
e1bb5a34-33fa-4d55-9ca1-ee4b6ef12dc2	8e6ce072-a54e-4e62-ac6b-eb24a4589613	ArcGIS FeatureServer Service		ags_fs_view	0	\N
7dcc445d-28c8-47aa-8580-ce90d3b039d8	2816377d-bbee-462a-821b-e063ece57c94	ArcGIS FeatureServer Service		ags_fs_view	0	\N
7716c76f-ad4e-4fd0-b9f0-7a39f7fe39d6	a34bc96a-b626-465e-8936-130ac11a3bef	ArcGIS FeatureServer Service		ags_fs_view	0	\N
feb38151-114e-4778-a5b5-baefbe2a09ee	9397ec86-26b4-47a5-8ef3-f81df6171692	ArcGIS FeatureServer Service		ags_fs_view	0	\N
4869b188-7d8f-47d3-8ae8-cc4553981822	3634c419-624a-4f7e-8f53-a50e956ab19f	ArcGIS FeatureServer Service		ags_fs_view	0	\N
776d8b89-ea2a-4eba-9e05-018bb69c9581	d4519cd9-37b7-4ec7-8b6d-081cb89e04b3	Website		webpage_view	0	\N
de1e662f-720d-4272-93f8-fc57f197709f	25f55fda-8a7d-4cbe-a064-c18cf94fd0cc	ArcGIS FeatureServer Service		ags_fs_view	0	\N
ab71201b-ad3e-47eb-ab03-29afce73690e	bdb2da13-42a5-401b-a6b2-c0d8bbf74099	Website		webpage_view	0	\N
6da73172-c19c-452d-b41e-d9bbbb442c63	792da1b2-ea4f-4c14-acd3-b84260c2aecb	ArcGIS FeatureServer Service		ags_fs_view	0	\N
adb47285-4e98-4b88-bfab-e8e5b224797d	23af5a3d-4187-4d6a-af4b-960fe05c21df	Website		webpage_view	0	\N
d0d2c032-983f-4b57-a34b-8e8f06d2cafc	2462df30-23e2-4c85-9560-7ee589f6fc3c	ArcGIS FeatureServer Service		ags_fs_view	0	\N
c86d884a-578f-4b42-8b92-e4bb0ab08888	7f76f800-08b6-429e-a1f4-5e0af8cd1d56	Website		webpage_view	0	\N
ad082ff3-34e0-4a35-91ec-ba528466c8cb	f3da664f-def6-45b6-a1f1-9a02e6cdeb73	ArcGIS FeatureServer Service		ags_fs_view	0	\N
026708af-11df-4b29-b8b4-3257c327ce78	a934f346-1bd3-4612-bc29-0bb73f31d2aa	Website		webpage_view	0	\N
cfa4d188-d80b-4b08-9538-37b554491c31	8a93ba11-5394-4fcb-b7f9-cb471203588f	ArcGIS FeatureServer Service		ags_fs_view	0	\N
07943d9e-a35a-4f7a-b82b-68a671095a9e	3350f17d-adbb-4433-8f0f-6e4fa7f886e6	Website		webpage_view	0	\N
ec7437b7-e250-4e81-80d9-bddc21bb1a71	bcba6658-8d12-4525-97ae-c163a8fcc410	Website		webpage_view	0	\N
6692dec4-b000-4a6e-95c6-6a56b191390a	cc75f3b8-3b3e-4353-b097-5af3af910f31	Data Explorer		recline_view	0	\N
1ce762aa-4f96-4d7b-baf2-4bc459da36bf	5720c32a-3c70-4294-b5e6-3d3dc60df392	Data Explorer		recline_view	0	\N
8141658d-38a0-4f62-86fc-db9359b8723f	27d1e320-4d6f-4fdb-8c26-4a7cb9679757	Website		webpage_view	0	\N
d122509d-a6db-4fed-97a9-4e7cb4c25486	0c3d5586-4c49-4861-83b5-0f555d3e2e71	Website		webpage_view	0	\N
434c33ae-627c-4b9a-9bbe-bdcf3dc56a95	0a98d965-3bbf-429c-8d04-bdf6e3859230	ArcGIS FeatureServer Service		ags_fs_view	0	\N
142eb89e-8067-42f1-9ade-4e0324ea7d24	cc75f3b8-3b3e-4353-b097-5af3af910f31	ArcGIS FeatureServer Service		ags_fs_view	1	\N
596faaf3-3b14-4d66-aeba-c162a95c0f46	62b8aa66-8172-4b5d-9684-fcfaf6b66ba6	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
edd17cef-3572-4a21-a4c2-97282ffa8d12	c214fa81-e1f9-4e2f-9898-a5f7080163dd	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
1c5d8f18-b2f7-4701-b2d5-f486fc42ed6a	c1624a24-eb88-4cd6-9234-f490453a92ab	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
9a1e9372-2cc5-4c20-82c3-f227c814f006	6a5af96a-b112-4e0c-88fc-59f010821471	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
a858db38-da88-4596-8b62-6ce664ea525f	ccdda121-01aa-417b-95df-085bd84bbe26	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
b8b65171-5489-410e-9702-aef43e057c65	7825dc2f-621f-4ec7-8294-de3a16211bad	Website		webpage_view	0	\N
a2ddc782-d434-45a9-8aff-e9df03ef66a3	af864d9f-47fe-415b-b110-79f9fef59897	Website		webpage_view	0	\N
28bf140a-4256-4dd3-a649-7212ea6db3ac	7ced7925-5a56-4f29-97ad-15542412b133	Website		webpage_view	0	\N
4b5fa967-509e-4810-b5c6-1e2b8435986d	9fe2992f-f3d6-4050-88ec-693a117df9f3	ArcGIS FeatureServer Service		ags_fs_view	0	\N
65689bfd-02ce-49d0-bc43-d7a2346a51f8	97ebd25f-c38a-4837-afd7-3256bebe8486	ArcGIS FeatureServer Service		ags_fs_view	0	\N
9527a820-e3dd-43e8-8934-6aad2ed16fd6	7a5b631b-6070-4fe5-9f36-b82c18e56e60	Website		webpage_view	0	\N
dd3c8a82-ac44-42c2-b5e7-81ef1e51f850	4a2fd664-4cbe-4779-a77d-eb4b619d5761	Data Explorer		recline_view	0	\N
3777a64a-1bf4-4f46-82e0-45a106457555	98ae4c58-a64e-4348-9afd-923489eadbb1	Website		webpage_view	0	\N
6a989853-6b95-45d1-a29c-db006e08d257	ebbf742e-8347-457b-89a1-d7b8a615764b	ArcGIS FeatureServer Service		ags_fs_view	0	\N
98ca38ef-dfbb-4a80-ac7b-1a31d4b5fc68	2ab4a2bb-1e25-4234-b898-28a7d09395d2	ArcGIS FeatureServer Service		ags_fs_view	0	\N
7965399e-43c9-4759-9341-01850ced33c8	f83930bd-4732-408b-8eac-ae33b6e75074	ArcGIS FeatureServer Service		ags_fs_view	0	\N
6436d632-03e8-42be-8ef1-711ffb50ea31	e3022684-6c6d-46bd-af2a-f421fbf73793	ArcGIS FeatureServer Service		ags_fs_view	0	\N
d2b14f6a-8344-48c6-b118-da9e4dc2a973	8fdec72c-f58a-4ea2-82ff-c81402c49fc4	Website		webpage_view	0	\N
4c29c8cf-d6ad-4ff4-8752-f6dec546fd4b	428e8b36-61c4-4150-8304-d5733fa78c15	ArcGIS FeatureServer Service		ags_fs_view	0	\N
c1f9aca9-be0c-41b5-8b06-13b1980f2043	054a02e9-fa2e-4de7-b7aa-424775fe71de	Website		webpage_view	0	\N
a63512b6-c639-48fc-aaf7-ef06be9d5805	08268790-749c-494c-b1ff-268bd5bad532	ArcGIS FeatureServer Service		ags_fs_view	0	\N
f591c6b1-c28b-4fbd-85d2-3ddea2ca4e18	ff1c0401-7c1e-442d-a8b1-d692950728cd	ArcGIS FeatureServer Service		ags_fs_view	0	\N
891ca91d-fa27-4caa-af60-e9f4f4b8dba6	04ea080d-308a-4058-9a80-6daeb2cb44dc	ArcGIS FeatureServer Service		ags_fs_view	0	\N
86cb2384-ddd7-480a-947e-2c5f120d5a1f	e7b01468-1780-413f-9f89-2749fc6bf620	Website		webpage_view	0	\N
4c33811f-bd40-47e3-83cf-7ff5bd4947e0	5fca5809-361d-4194-8fe7-e636241600d2	ArcGIS FeatureServer Service		ags_fs_view	0	\N
26188edf-d8dc-4f48-95df-f138483a5d34	3551b726-2191-45dc-a930-189af6d80815	ArcGIS FeatureServer Service		ags_fs_view	0	\N
9f361cc2-63ea-47f3-9b9e-f53487377455	cd87e702-ad40-4f09-b111-fb6da507be8b	ArcGIS FeatureServer Service		ags_fs_view	0	\N
5454356e-659e-4016-bc15-23540c93045d	e1d7449a-a693-4f06-9e36-4492c2abebff	Website		webpage_view	0	\N
864e434a-ef5e-4bfb-ad3c-a7e9d57797a7	b92287a8-bb87-4387-95ec-7db9900e7c91	Website		webpage_view	0	\N
11310a29-095b-40d2-8511-f4beea1e591d	d5057dab-d8df-4d6e-aba0-298375bf28e6	ArcGIS FeatureServer Service		ags_fs_view	0	\N
b95d7ceb-249a-4bc0-b26b-2a0156bd9135	8822d2c4-97ab-4490-a827-1662d45cc530	Website		webpage_view	0	\N
fd4ffcf1-f806-4387-8b2c-d27378f63a1f	67e36eae-ff74-4497-be04-e7412897ef9a	ArcGIS FeatureServer Service		ags_fs_view	0	\N
c39775b3-0880-4dae-992d-a78c8ab02b9e	46daab7d-7c34-450a-9177-8f5793318407	Website		webpage_view	0	\N
676a3089-b931-4380-b709-860b0e310bb7	01e791ea-f574-4862-adf8-123a42f8c22a	ArcGIS FeatureServer Service		ags_fs_view	0	\N
d83d5a43-f512-4213-8e57-46245832b60f	7dd211ac-0d5c-4273-86ce-e83121fa7ff9	Website		webpage_view	0	\N
4fac593e-5d8a-43cb-b464-414198315d93	ded356c2-b3a0-4b80-92ab-4a9d1a75d84c	Website		webpage_view	0	\N
4ebb6cb5-946f-4357-8307-0f9c5bd16e79	f0d3f836-19d7-407f-8598-3b6f57f5e945	ArcGIS FeatureServer Service		ags_fs_view	0	\N
231f067c-6f47-4cd9-b43f-90c8a08a8a89	bb16fe69-ba59-43bc-b0fa-1928e955e728	ArcGIS FeatureServer Service		ags_fs_view	0	\N
5c48162c-1f11-4aff-8e50-fdab18cf502a	c3bfb1b2-e03e-4e20-bdf1-f401144c82ba	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
25b06a82-5ea8-42f2-bc72-c60820f8a835	3e0a3c0d-8d5a-4061-b3f8-15091dc42d4b	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
29f4cf99-1398-4cc1-915e-179ce02e25e7	6121693b-2826-4672-87d7-528420125edf	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
ef1caadc-47b7-4a07-8e52-5620fc446bc1	a31ea0b9-f883-432b-a70a-5493eeb622e9	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
0fad3944-f687-4832-b884-2f247d6f06da	f8135dcc-6f5e-417d-9029-abd8eb1ed43e	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
926ecd26-6895-4c92-82c6-49b7ba555c92	245c7544-29e9-4d26-950b-35b51cdfdd24	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
2b399b18-4452-447a-b1f8-352f688005d4	ab43708c-6c3e-4dc1-88a1-dc140a60815c	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
89164472-992b-41cc-a3b9-124b25c22673	7257eff5-51c1-4fda-bafc-25756d96d893	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
2002091a-484b-4ebd-a481-2762f449ed46	28ce3aca-55b5-441c-acba-bbb35441c2cf	Map viewer		geo_view	0	{"feature_hoveron": true}
62eba64a-7b5e-4cac-86bb-f40b91816da5	7d21581f-e67c-42c4-a029-9e313a17793a	Map viewer		geo_view	0	{"load_layername": true, "feature_hoveron": true}
\.


--
-- TOC entry 2673 (class 2606 OID 19255)
-- Name: resource_view_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default; Tablespace: 
--

ALTER TABLE ONLY public.resource_view
    ADD CONSTRAINT resource_view_pkey PRIMARY KEY (id);


--
-- TOC entry 2674 (class 2606 OID 19256)
-- Name: resource_view_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.resource_view
    ADD CONSTRAINT resource_view_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2018-05-08 21:40:24 -05

--
-- PostgreSQL database dump complete
--

