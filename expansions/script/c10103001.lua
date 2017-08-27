--界限龙 努特
function c10103001.initial_effect(c)
	c:EnableUnsummonable()
	--XYZ
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10103001,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,10103001)
	e1:SetTarget(c10103001.xyztg)
	e1:SetOperation(c10103001.xyzop)
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10103001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10103101)
	e2:SetTarget(c10103001.sptg)
	e2:SetOperation(c10103001.spop)
	c:RegisterEffect(e2)
	c10103001[c]=e2 
end
function c10103001.spfilter(c,e,tp)
	return c:IsSetCard(0x337) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10103001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10103001.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10103001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10103001.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		g:GetFirst():RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		g:GetFirst():RegisterEffect(e2,true)
	end
end
function c10103001.xyzfilter(c,tp,mc,ft)
	return c:IsSetCard(0x337) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsOnField()) and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,mc),2,2) and (ft>0 or (c:IsOnField() or mc:IsOnField()))
end
function c10103001.xyztg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c,ft=e:GetHandler(),Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c10103001.xyzfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tp,c,ft) end
end
function c10103001.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c,ft=e:GetHandler(),Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(c10103001.xyzfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c,tp,c,ft)
	if mg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mc=mg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyzg=Duel.SelectMatchingCard(tp,Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,1,nil,Group.FromCards(c,mc),2,2)
	Duel.XyzSummon(tp,xyzg:GetFirst(),Group.FromCards(c,mc))
	Duel.ShuffleHand(tp)
end