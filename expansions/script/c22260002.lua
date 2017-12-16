--负的集合 球磨川禊
function c22260002.initial_effect(c)
	--xyzlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c22260002.mlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22260002.spcon)
	c:RegisterEffect(e1)
	--SearchCard
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22260002,0))
	e7:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c22260002.thcost)
	e7:SetTarget(c22260002.thtg)
	e7:SetOperation(c22260002.thop)
	c:RegisterEffect(e7)
end
c22260002.named_with_KuMaKawa=1
function c22260002.IsKuMaKawa(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KuMaKawa
end
function c22260002.sumlimit(e,c)
	return c:GetAttack()~=0
end
function c22260002.mlimit(e,c)
	if not c then return false end
	return c:GetAttack()~=0
end
function c22260002.spfilter(c)
	return c:IsFacedown() or c:GetBaseAttack()~=0
end
function c22260002.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetMatchingGroupCount(c22260002.spfilter,tp,LOCATION_MZONE,0,nil)==0
end
function c22260002.cfilter(c)
	return c:IsCode(22269999) and c:IsReleasable()
end
function c22260002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22260002.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c22260002.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22260002.thfilter(c)
	return c:IsCode(22260001,22261001,22261101) and c:IsAbleToHand()
end
function c22260002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22260002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22260002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22260002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end