--太古龙·诡谲龙
function c10162006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--fusion material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c10162006.fscon)
	e2:SetOperation(c10162006.fsop)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c10162006.sprcon)
	e3:SetOperation(c10162006.sprop)
	c:RegisterEffect(e3)	
	--dark
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10162006,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c10162006.tdcost)
	e5:SetTarget(c10162006.tdtg)
	e5:SetOperation(c10162006.tdop)
	e5:SetCountLimit(1,10162006)
	c:RegisterEffect(e5) 
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c10162006.antarget)
	c:RegisterEffect(e6)  
end

function c10162006.antarget(e,c)
	return c~=e:GetHandler()
end

function c10162006.tdop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local g=Duel.SelectMatchingCard(tp,c10162006.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			 if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
				 local e1=Effect.CreateEffect(c)
				 e1:SetType(EFFECT_TYPE_SINGLE)
				 e1:SetCode(EFFECT_UPDATE_ATTACK)
				 e1:SetReset(RESET_EVENT+0x1fe0000)
				 e1:SetValue(math.floor(g:GetFirst():GetBaseAttack()))
				 c:RegisterEffect(e1)
			 end
		end
end

function c10162006.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsAttribute(ATTRIBUTE_DARK)
end

function c10162006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10162006.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_MZONE+LOCATION_GRAVE)
end

function c10162006.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c10162006.spfilter1(c,tp)
	return c:IsSetCard(0x9333) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c10162006.spfilter2,tp,LOCATION_MZONE,0,1,c,c:GetAttribute())
end

function c10162006.spfilter2(c,att)
	return c:IsSetCard(0x9333) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and c:IsAttribute(att)
end

function c10162006.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10162006.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end

function c10162006.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c10162006.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c10162006.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst():GetAttribute())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end

function c10162006.fscon(e,g,gc,chkf)
	if g==nil then return true end
	if gc then
		local mg=g:Filter(Card.IsSetCard,nil,0x9333)
		mg:AddCard(gc)
		return gc:IsSetCard(0x9333) and mg:GetClassCount(Card.GetAttribute)>=3
	end
	local fs=false
	local mg=g:Filter(Card.IsSetCard,nil,0x9333)
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:GetClassCount(Card.GetAttribute)>=2 and (fs or chkf==PLAYER_NONE)
end

function c10162006.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		local sg=eg:Filter(Card.IsSetCard,gc,0x9333)
		sg:Remove(Card.IsAttribute,nil,gc:GetAttribute())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(Card.IsSetCard,nil,0x9333)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	sg:Remove(Card.IsAttribute,nil,g1:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end