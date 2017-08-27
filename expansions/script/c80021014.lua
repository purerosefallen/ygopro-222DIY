--天堂 光明天使
function c80021014.initial_effect(c)
	--summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80021014,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c80021014.ntcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c80021014.splimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)	
	--disable effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e6:SetOperation(c80021014.disop1)
	c:RegisterEffect(e6) 
	--xyzlv
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_XYZ_LEVEL)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c80021014.xyzlv)
	c:RegisterEffect(e7)
	--search
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(80021014,1))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCountLimit(1,80021014)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c80021014.cost)
	e8:SetTarget(c80021014.target)
	e8:SetOperation(c80021014.operation)
	c:RegisterEffect(e8)
	--change name
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_ADD_SETCODE)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(0xa2d5)
	c:RegisterEffect(e10)
	Duel.AddCustomActivityCounter(80021014,ACTIVITY_SPSUMMON,c80021014.counterfilter)
end
function c80021014.cfilter(c,tp)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c80021014.filter,tp,LOCATION_DECK,0,1,c)
end
function c80021014.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or (c:IsLevelAbove(6) and c:IsAttribute(ATTRIBUTE_DARK))
end
function c80021014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80021014,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c80021014.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80021014.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c80021014.splimit1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80021014.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsRankAbove(6) and c:IsAttribute(ATTRIBUTE_DARK)) and c:IsLocation(LOCATION_EXTRA)
end
function c80021014.filter(c)
	return c:IsSetCard(0xa2d5) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c80021014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80021014.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c80021014.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80021014.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80021014.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x92d5)
end
function c80021014.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c80021014.disop1(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function c80021014.xyzlv(e,c,rc)
	return 0x70000+e:GetHandler():GetLevel()
end