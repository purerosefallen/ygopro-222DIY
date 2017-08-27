--动物朋友 九尾狐
function c33700173.initial_effect(c)
	  --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit() 
   --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c33700173.con)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x442))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700173,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c33700173.tgcon)
	e3:SetTarget(c33700173.tg)
	e3:SetOperation(c33700173.op)
	c:RegisterEffect(e3)
end
function c33700173.con(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),0,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetCode)<g:GetCount()
end
function c33700173.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c33700173.cgfilter(c)
	return  c:IsAbleToGrave() and c:IsSetCard(0x442) and c:IsFaceup()
end
function c33700173.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700173.cgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c33700173.op(e,tp,eg,ep,ev,re,r,rp)
	 local cg=Duel.GetMatchingGroup(c33700173.cgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if cg:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c33700173.cgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,cg:GetCount(),nil)
	local tg=Duel.SendtoGrave(sg,REASON_EFFECT)
	if tg>1 and Duel.GetTurnPlayer()==tp then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end
end
end