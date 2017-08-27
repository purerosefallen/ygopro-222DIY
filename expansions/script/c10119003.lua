--季风的使者 秋风的贝尔兹努
function c10119003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10119003,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10119003)
	e1:SetCondition(c10119003.spcon)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10119003,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	--e2:SetCountLimit(1,10119103)
	e2:SetTarget(c10119003.target)
	e2:SetOperation(c10119003.operation)
	c:RegisterEffect(e2)  
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c10119003.efcon)
	e3:SetOperation(c10119003.efop)
	--c:RegisterEffect(e3) 
end 

function c10119003.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end

function c10119003.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c10119003.caop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end

function c10119003.caop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_XYZ then return end
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_CANNOT_ATTACK)
		  e1:SetProperty(EFFECT_FLAG_OATH)
		  e1:SetTargetRange(LOCATION_MZONE,0)
		  e1:SetTarget(c10119003.ftarget)
		  e1:SetLabel(e:GetHandler():GetFieldID())
		  e1:SetReset(RESET_PHASE+PHASE_END)
		  Duel.RegisterEffect(e1,tp)
end

function c10119003.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end

function c10119003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetPreviousLocation()==LOCATION_OVERLAY and Duel.IsExistingMatchingCard(c10119003.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c10119003.thfilter(c)
	return c:IsCode(10119004) and c:IsAbleToHand()
end

function c10119003.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c10119003.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

function c10119003.spfilter(c)
	return c:IsFaceup() and c:IsCode(10119002)
end

function c10119003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10119003.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
