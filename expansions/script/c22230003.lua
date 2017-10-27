--Darkest　圣职者
function c22230003.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230003,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,222300031)
	e1:SetTarget(c22230003.thtg)
	e1:SetOperation(c22230003.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c22230003.flipop)
	c:RegisterEffect(e2)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230003,2))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,222300032)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22230003.negcon)
	e1:SetTarget(c22230003.negtg)
	e1:SetOperation(c22230003.negop)
	c:RegisterEffect(e1)
end
c22230003.named_with_Darkest_D=1
function c22230003.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22230003.filter(c)
	return c22230003.IsDarkest(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function c22230003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22230003.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	if e:GetHandler():GetFlagEffect(22230003)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(22230003)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c22230003.spfilter(c,e,tp)
	return c22230003.IsDarkest(c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c22230003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22230003.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c22230003.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(22230003,1)) then
			local g=Duel.SelectMatchingCard(tp,c22230003.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c22230003.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22230003,0,0,0)
end
function c22230003.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown()
end
function c22230003.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c22230003.cfilter,1,nil) and Duel.IsChainNegatable(ev)
end
function c22230003.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22230003.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and e:GetHandler():IsLocation(LOCATION_HAND) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end


