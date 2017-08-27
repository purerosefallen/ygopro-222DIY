--绯樱的剑舞姬 鬼姬
function c121029293.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c121029293.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c121029293.spcon)
	e2:SetOperation(c121029293.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c121029293.efilter)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c121029293.efilter)
	e5:SetValue(800)
	c:RegisterEffect(e5)
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c121029293.thcon)
	e6:SetTarget(c121029293.thtg)
	e6:SetOperation(c121029293.thop)
	c:RegisterEffect(e6)
	--tograve
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCode(EVENT_BECOME_TARGET)
	e7:SetCondition(c121029293.condition)
	e7:SetTarget(c121029293.target)
	e7:SetOperation(c121029293.activate)
	c:RegisterEffect(e7)
end
function c121029293.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c121029293.spfilter1(c,tp,fc)
	return c:IsFusionCode(121029233)  and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c121029293.spfilter2,1,c,fc)
end
function c121029293.spfilter2(c,fc)
	return  c:IsFusionCode(121053292)   and c:IsCanBeFusionMaterial(fc)
end
function c121029293.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c121029293.spfilter1,1,nil,tp,c)
end
function c121029293.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c121029293.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c121029293.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c121029293.efilter(e,c)
	return c:IsSetCard(0x121) and c:IsFaceup()
end
function c121029293.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c121029293.thfilter(c)
	return c:IsSetCard(0x121)  and c:IsFaceup() and  c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c121029293.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c121029293.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c121029293.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c121029293.thfilter,tp,LOCATION_EXTRA,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c121029293.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c121029293.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,0)
end

function c121029293.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil)
	local dg2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
		if dg1:GetCount()<=0 or dg2:GetCount()<=0 then return end
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		 local sg1=dg1:Select(tp,1,1,nil)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		 local sg2=dg2:Select(tp,1,1,nil)
		 sg1:Merge(sg2)
		 Duel.HintSelection(sg1)
		 Duel.SendtoGrave(sg1,REASON_EFFECT)
end
