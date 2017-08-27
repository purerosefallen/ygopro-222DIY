--★マジカルマヨちゃん
function c114000181.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(c114000181.material),2,true)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c114000181.condition)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c114000181.sptg)
	e1:SetOperation(c114000181.spop)
	c:RegisterEffect(e1)
end

function c114000181.material(c)
	return c:IsSetCard(0xcabb) 
		or c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) --0x224
end

function c114000181.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and not e:GetHandler():IsStatus(STATUS_CHAINING)
end

function c114000181.mgfilter(c,e,tp,fusc)
	return not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE)
		or bit.band(c:GetReason(),0x40008)~=0x40008 or c:GetReasonCard()~=fusc  -- 40008=0x40000(融合) + 0x8(作为融合/同调/超量素材)
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c114000181.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetMaterial()
	if chk==0 then return e:GetHandler():IsAbleToDeck() 
		and g:GetCount()>0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)+1>=g:GetCount() 
		and bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
		and not g:IsExists(c114000181.mgfilter,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end

function c114000181.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=e:GetHandler():GetMaterial()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()
		and not g:IsExists(c114000181.mgfilter,1,nil,e,tp,e:GetHandler()) then
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

