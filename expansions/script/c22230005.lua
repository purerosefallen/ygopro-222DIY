--Darkest　神秘学者
function c22230005.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230005,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,222300051)
	e1:SetTarget(c22230005.thtg)
	e1:SetOperation(c22230005.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c22230005.flipop)
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22230005,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_POSITION)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,222300052)
	e4:SetCondition(c22230005.negcon)
	e4:SetTarget(c22230005.negtg)
	e4:SetOperation(c22230005.negop)
	c:RegisterEffect(e4)
end
c22230005.named_with_Darkest_D=1
function c22230005.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22230005.filter(c)
	return c22230005.IsDarkest(c) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c22230005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22230005.filter,tp,LOCATION_DECK,0,1,nil) end
	if e:GetHandler():GetFlagEffect(22230005)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(22230005)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22230005.sfilter(c)
	return c22230005.IsDarkest(c) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c22230005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22230005.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c22230005.sfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22230005,1)) then
			local sg=Duel.SelectMatchingCard(tp,c22230005.sfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SSet(tp,sg)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c22230005.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22230005,0,0,0)
end
function c22230005.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=tp
end
function c22230005.thfilter(c,tpe)
	return c22230005.IsDarkest(c) and c:IsType(tpe) and c:IsSSetable()
end
function c22230005.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tpe=re:GetHandler():GetType()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c22230005.thfilter,tp,LOCATION_GRAVE,0,1,nil,tpe) and e:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c22230005.negop(e,tp,eg,ep,ev,re,r,rp)
	local tpe=re:GetHandler():GetType()
	if not (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.IsExistingMatchingCard(c22230005.thfilter,tp,LOCATION_GRAVE,0,1,nil,tpe))then return false end
	local sg=Duel.SelectMatchingCard(tp,c22230005.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tpe)
	if sg then 
		if Duel.SSet(tp,sg)>0 then
			Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
		end
	end
end