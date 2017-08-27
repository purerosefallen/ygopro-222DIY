--玫瑰之灵女 无傲
function c80004014.initial_effect(c)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCountLimit(2,80004014)
	e4:SetCondition(c80004014.spcon)
	e4:SetOperation(c80004014.spop)
	c:RegisterEffect(e4) 
	--ritual level
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_RITUAL_LEVEL)
	e5:SetValue(c80004014.rlevel)
	c:RegisterEffect(e5)
	--ritual material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80004014,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(2,80004015)
	e1:SetTarget(c80004014.sptg)
	e1:SetOperation(c80004014.spop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c80004014.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c80004014.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x2dd) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c80004014.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_PLANT) and c:IsAbleToRemoveAsCost()
end
function c80004014.spfilter1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
end
function c80004014.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80004014.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) 
		and Duel.IsExistingMatchingCard(c80004014.spfilter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function c80004014.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80004014.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(80004014,0))
	local sg=Duel.SelectMatchingCard(tp,c80004014.spfilter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST+REASON_RETURN)
end
function c80004014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80004014.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if not ((tc:IsRace(RACE_PLANT) and tc:IsAttribute(ATTRIBUTE_WIND)) or (tc:IsRace(RACE_SPELLCASTER) and tc:IsAttribute(ATTRIBUTE_DARK))) then 
		Duel.BreakEffect()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.ShuffleHand(tp)
end