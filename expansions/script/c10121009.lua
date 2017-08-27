--李奥瑞克 骷髅王
function c10121009.initial_effect(c)
	--race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e1) 
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10121009,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c10121009.destg)
	e2:SetOperation(c10121009.desop)
	c:RegisterEffect(e2)	  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetOperation(c10121009.op)
	c:RegisterEffect(e4) 
end

function c10121009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function c10121009.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.Destroy(c,REASON_EFFECT)
	end
end
function c10121009.op(e,tp,eg,ep,ev,re,r,rp)
	   --spsummon
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PHASE+PHASE_END)
	   e1:SetCountLimit(1)
	   e1:SetRange(LOCATION_GRAVE)
	   e1:SetCondition(c10121009.spcon)
	   e1:SetOperation(c10121009.spop)
	   if Duel.GetTurnPlayer()==tp then
		 e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	   else
		 e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	   end
	   e1:SetLabel(Duel.GetTurnCount())
	   e:GetHandler():RegisterEffect(e1)
end
function c10121009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()
end
function c10121009.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10121009)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
