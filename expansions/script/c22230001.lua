--Darkest　十字军
function c22230001.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230001,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,22230001)
	e1:SetTarget(c22230001.thtg)
	e1:SetOperation(c22230001.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c22230001.flipop)
	c:RegisterEffect(e2)
	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22230001,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22230001.cbcon)
	e2:SetTarget(c22230001.cbtg)
	e2:SetOperation(c22230001.cbop)
	c:RegisterEffect(e2)
end
c22230001.named_with_Darkest_D=1
function c22230001.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22230001.filter(c)
	return c22230001.IsDarkest(c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function c22230001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22230001.filter,tp,LOCATION_DECK,0,1,nil) end
	if e:GetHandler():GetFlagEffect(22230001)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(22230001)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22230001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22230001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetLabel()==1 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) 
		and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(22230001,1)) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c22230001.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22230001,0,0,0)
end
function c22230001.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil and Duel.GetAttackTarget():IsFacedown() and Duel.GetAttacker():IsCanTurnSet() and e:GetHandler():IsCanTurnSet()
end
function c22230001.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22230001.cbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(Duel.GetAttacker(),POS_FACEDOWN_DEFENSE)
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end