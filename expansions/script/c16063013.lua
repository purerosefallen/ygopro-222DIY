--kalula
function c16063013.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16063013,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c16063013.ntcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot des
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16063013,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,16063013)
	e4:SetCondition(c16063013.thcon)
	e4:SetTarget(c16063013.thtg)
	e4:SetOperation(c16063013.thop)
	c:RegisterEffect(e4)
end
function c16063013.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5c5)
end
function c16063013.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetMZoneCount(c:GetControler())>0
		and Duel.IsExistingMatchingCard(c16063013.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c16063013.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end
function c16063013.thfilter(c)
	return c:IsSetCard(0x5c5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c16063013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16063013.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c16063013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16063013.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end