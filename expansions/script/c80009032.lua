--ＤＭ 巴鲁兽
function c80009032.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,80009032)
	e1:SetCondition(c80009032.spcon)
	c:RegisterEffect(e1)  
	--reg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c80009032.regop)
	c:RegisterEffect(e3)  
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80009032,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,80009033)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c80009032.thcon)
	e4:SetTarget(c80009032.thtg)
	e4:SetOperation(c80009032.thop)
	c:RegisterEffect(e4)
end
function c80009032.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d5) and c:IsRace(RACE_PLANT)
end
function c80009032.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80009032.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c80009032.thfilter(c)
	return c:IsSetCard(0x2d5) and c:IsRace(RACE_PLANT) and c:IsAbleToHand() and not c:IsCode(80009032)
end
function c80009032.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80009032.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80009032.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80009032.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80009032.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(80009032,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c80009032.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(80009032)>0
end