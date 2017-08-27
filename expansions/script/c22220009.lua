--幸运的白泽球
function c22220009.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCode(EVENT_DRAW)
	e1:SetCountLimit(1,22220009)
	e1:SetCondition(c22220009.spcon)
	e1:SetCost(c22220009.spcost)
	e1:SetTarget(c22220009.sptg)
	e1:SetOperation(c22220009.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220009,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c22220009.negcon)
	e2:SetTarget(c22220009.negtg)
	e2:SetOperation(c22220009.negop)
	c:RegisterEffect(e2)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220009,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22220009.target)
	e2:SetOperation(c22220009.operation)
	c:RegisterEffect(e2)
end
c22220009.named_with_Shirasawa_Tama=1
function c22220009.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22220009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()~=e:GetHandler()
end
function c22220009.filter(c)
	return c:GetLevel()==2 and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c22220009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp and eg:IsExists(c22220009.filter,1,nil) end
	local g=eg:Filter(c22220009.filter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.ShuffleHand(tp)
end
function c22220009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22220009.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function c22220009.negcon(e,tp,eg,ep,ev,re,r,rp)
	return (re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_HAND) and Duel.IsChainNegatable(ev)
end
function c22220009.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c22220009.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local sc=g:GetFirst()
	if sc:IsRace(RACE_BEAST) and sc:IsAbleToRemove() then
		Duel.ConfirmCards(1-tp,sc)
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
		Duel.NegateActivation(ev)
	end
end
function c22220009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c22220009.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetDecktopGroup(tp,1)
	local sc=g:GetFirst()
	if Duel.Remove(sc,POS_FACEUP,REASON_EFFECT) and c22220009.IsShirasawaTama(sc) and tc:IsRelateToEffect(e) then 
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end