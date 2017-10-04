--Darkest　强盗
function c22230002.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230002,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,222300021)
	e1:SetTarget(c22230002.postg)
	e1:SetOperation(c22230002.posop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c22230002.flipop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22230002,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,222300022)
	e3:SetTarget(c22230002.target)
	e3:SetOperation(c22230002.operation)
	c:RegisterEffect(e3)
end
c22230002.named_with_Darkest_D=1
function c22230002.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22230002.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c22230002.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22230002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22230002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22230002.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	if e:GetHandler():GetFlagEffect(22230002)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(22230002)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22230002.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
	if e:GetLabel()==1 and Duel.SelectYesNo(tp,aux.Stringid(22230002,1)) and e:GetHandler():IsCanTurnSet() then
		Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
	end
end
function c22230002.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22230002,0,0,0)
end
function c22230002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22230002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) or tc:IsFacedown()) then return false end
	local c=e:GetHandler()
	if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)>0 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end