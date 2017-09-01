--Darkest　巨炮
function c22230124.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_FLIP),3,2)
	c:EnableReviveLimit()
	--pos change
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c22230124.postg)
	e3:SetOperation(c22230124.posop)
	c:RegisterEffect(e3)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230124,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,22230124)
	e1:SetCost(c22230124.tdcost)
	e1:SetTarget(c22230124.tdtg)
	e1:SetOperation(c22230124.tdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetOperation(c22230124.flipop)
	c:RegisterEffect(e2)
end
c22230124.named_with_Darkest_D=1
function c22230124.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22230124.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and e:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c22230124.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsCanTurnSet() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function c22230124.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22230124.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	if e:GetHandler():GetFlagEffect(22230121)~=0 then
		Duel.SetChainLimit(aux.FALSE)
		e:GetHandler():ResetFlagEffect(22230121)
	end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c22230124.mafilter(c,tp)
	return c22230124.IsDarkest(c) and c:IsType(TYPE_MONSTER)
end
function c22230124.xyzfilter(c,tp)
	return c22230124.IsDarkest(c) and c:IsType(TYPE_XYZ)
end
function c22230124.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	if g:IsExists(Card.IsType,1,nil,TYPE_FLIP) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22230123,5)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(22230123,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_FUSION) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22230123,2)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		Duel.Remove(g:RandomSelect(tp,1),POS_FACEUP,REASON_EFFECT)
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_PENDULUM) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_PZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22230123,3)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_PZONE,1,1,nil)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) and Duel.IsExistingMatchingCard(c22230124.xyzfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22230124.mafilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22230123,4)) then
		Duel.BreakEffect()
		local xyzg=Duel.GetMatchingGroup(c22230124.xyzfilter,tp,LOCATION_MZONE,0,nil)
		local m=xyzg:GetCount()
		local mag=Duel.SelectMatchingCard(tp,c22230124.mafilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,m,nil)
		while mag:GetCount()>0 and xyzg:GetCount()>0 do
			local tg=xyzg:Select(tp,1,1,nil)
			local mg=mag:Select(tp,1,1,nil)
			Duel.Overlay(tg:GetFirst(),mg:GetFirst())
			xyzg:RemoveCard(tg:GetFirst())
			mag:RemoveCard(mg:GetFirst())
		end
	end
end
function c22230124.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22230124,0,0,0)
end