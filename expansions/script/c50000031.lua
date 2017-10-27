--Warpko 淩汐
function c50000031.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50000031)
	e1:SetCost(c50000031.spcost)
	e1:SetTarget(c50000031.sptg)
	e1:SetOperation(c50000031.spop)
	c:RegisterEffect(e1)   
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000031,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,500000311)
	e2:SetCondition(c50000031.drcon)
	e2:SetTarget(c50000031.drtg)
	e2:SetOperation(c50000031.drop)
	c:RegisterEffect(e2) 
end
function c50000031.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c50000031.spfilter(c,e,tp)
	return c:IsSetCard(0x50a)  and not c:IsCode(50000031) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c50000031.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c50000031.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50000031.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		 Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end


function c50000031.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_DECK) and re:GetHandler():IsSetCard(0x50a)
end
function c50000031.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50000031.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end